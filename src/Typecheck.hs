{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
module Typecheck (
        typecheck,
        Symbols(functions, structs, typeDefs),
        FunctionSig(FunctionSig)
    ) where

import Javalette.Abs

import qualified Data.Map.Lazy as Map
import Data.List.Unique
import Control.Monad
import Control.Monad.Trans ( MonadTrans(lift) )
import Control.Monad.Trans.RWS
import Control.Monad.Trans.Except ( runExceptT, ExceptT, throwE, catchE)
import Data.Either (lefts, rights)

data FunctionSig = FunctionSig Type [Type]
    deriving Show
type Structure = (Map.Map Ident Type)
type TDef = Ident

-- The list of maps represents variables, forming a stack to permit shadowing
type SymbolsRWS = RWS Symbols () [Map.Map Ident Type]
type TCExceptRWS = ExceptT String SymbolsRWS
data Symbols = Symbols
    { functions :: Map.Map Ident FunctionSig
    , structs :: Map.Map Ident Structure
    , typeDefs :: Map.Map Ident TDef
    }


typecheck :: Prog -> Either String (Prog, Symbols)
typecheck (Program [])     = Left "No function definitions found"
typecheck prog@(Program topdefs) = case initFunctionSigs prog of
    Left err -> Left err
    Right fsigs -> case lefts checkedTds of
        []  -> Right (Program (rights checkedTds), symbols)
        ers -> Left (unlines ers)
        where
            checkedTds = checkedFns ++ checkedTypeDefs ++ checkedStructs
            checkedFns = map (fst . checkFns) fnTds
            checkedTypeDefs = map (fst . checkTypeDef) typeDefTds
            checkedStructs = map (fst . checkStruct) structTds
            checkFns fn = evalRWS (runExceptT (typecheckFunction fn)) symbols [functionArgTypes fn]
            checkTypeDef td = evalRWS (runExceptT (typecheckTypeDef td)) symbols []
            checkStruct strc = evalRWS (runExceptT (typecheckStruct strc)) symbols []
            fnTds = [ fn | fn@FnDef {} <- topdefs]
            typeDefTds = [ td | td@TypeDef {} <- topdefs]
            structTds = [ strc | strc@StructDef {} <- topdefs]
            symbols = Symbols {
                functions = fsigs,
                structs = Map.empty,
                typeDefs = Map.empty
            }




functionArgTypes :: TopDef -> Map.Map Ident Type
functionArgTypes (FnDef _ _ args _) = Map.fromList (functionArgTypes' args)
functionArgTypes _ = error "functionArgTypes called on non FnDef topdef"

functionArgTypes' :: [Arg] -> [(Ident, Type)]
functionArgTypes' [] = []
functionArgTypes' ((Argument t ident):as) = (ident, t) : functionArgTypes' as

initFunctionSigs :: Prog -> Either String (Map.Map Ident FunctionSig)
initFunctionSigs (Program defs) = case repeated fidents of
        [] -> case Map.lookup (Ident "main") funs of
            Nothing -> Left "No main function!"
            Just (FunctionSig Int []) -> Right funs
            Just _ -> Left "Main function has wrong signature!"
        (ident:_) -> Left ("Topdef " ++ show ident ++ " defined multiple times")
    where
        funs = Map.fromList fsigs
        fsigs = primitiveFunctions ++ initFunctionSigs' defs
        fidents = map fst fsigs

primitiveFunctions :: [(Ident, FunctionSig)]
primitiveFunctions = [
    (Ident "printInt", FunctionSig Void [Int]),
    (Ident "printDouble", FunctionSig Void [Doub]),
    (Ident "readInt", FunctionSig Int []),
    (Ident "readDouble", FunctionSig Doub [])
    ]

initFunctionSigs' :: [TopDef] -> [(Ident, FunctionSig)]
initFunctionSigs' []     = []
initFunctionSigs' ((FnDef retType ident args _):tds) =
    (ident, FunctionSig retType argTypes) : initFunctionSigs' tds
    where
        argTypes = map argToType args
initFunctionSigs' (_:tds) = initFunctionSigs' tds

initStructures :: [TopDef] -> [(Ident, Structure)]
initStructures [] = []
initStructures ((StructDef ident mems):tds) = (ident, initStructMems mems) : initStructures tds
    where
        initStructMems mms = Map.fromList (map initStructMem mms)
        initStructMem (Member mType mIdent) = (mIdent, mType)
initStructures (_:tds) = initStructures tds

initTypeDefs :: [TopDef] -> [(Ident, TDef)]
initTypeDefs [] = []
initTypeDefs ((TypeDef srcType newName):tds) = (newName, srcType) : initTypeDefs tds
initTypeDefs (_:tds) = initTypeDefs tds


argToType :: Arg -> Type
argToType (Argument t _) = t

typecheckTypeDef :: TopDef -> TCExceptRWS TopDef
typecheckTypeDef = undefined

typecheckStruct :: TopDef -> TCExceptRWS TopDef
typecheckStruct = undefined

-- I'm checking that the function returns separate from the main pass. 
-- It's a lot slower but simplifies the functions
typecheckFunction :: TopDef -> TCExceptRWS TopDef
typecheckFunction topdef@(FnDef Void _id _args _blk) = do
    fixedTopdef <- implicitReturn topdef
    typecheckFunction' fixedTopdef
typecheckFunction topdef@(FnDef _retType _id _args (Block stms)) = if allPathsReturn stms
    then typecheckFunction' topdef
    else throwE "Function is not guaranteed to return a value"
typecheckFunction _ = throwE "typecheckFunction called on non function!"


typecheckFunction' :: TopDef -> TCExceptRWS TopDef
typecheckFunction' (FnDef retType ident args (Block stms)) = do
    if Void `elem` map argToType args then
            throwE "Void is not allowed as a argument type"
        else
            FnDef retType ident args . Block <$> checkedStms
    where
        checkedStms = mapM (typecheckStatement retType) stms
typecheckFunction' _ = throwE "typecheckFunction' Called on non Function!"

-- Make implicit returns explicit
implicitReturn :: TopDef -> TCExceptRWS TopDef
implicitReturn (FnDef Void fid args (Block stms)) = return $ FnDef Void fid args (Block (stms ++ [VRet]))
implicitReturn _ = throwE "Only void functions can have implicit return"




typecheckStatement :: Type -> Stmt -> TCExceptRWS Stmt
typecheckStatement _ Empty = return Empty
typecheckStatement retType (BStmt (Block stms)) = do
    -- Add a new layer to the variable stack to allow shadowing
    old_state <- lift get
    lift $ put $ Map.empty:old_state
    checkedStms <- mapM (typecheckStatement retType) stms
    -- Restore old state
    lift $ put old_state
    return (BStmt (Block checkedStms))
typecheckStatement _ (Decl vType decls) = do
    checkedDeclarations <- mapM (typecheckDeclaration vType) decls
    return (Decl vType checkedDeclarations)
typecheckStatement _ (Ass lExpr assExpr) = do
    checkedLExpr <- typecheckExpression lExpr
    lType <- extractType checkedLExpr
    checkedAssExpr <- typecheckExpression assExpr
    assType <- extractType checkedAssExpr
    if lType == assType then
        return $ Ass checkedLExpr checkedAssExpr
    else
        throwE "Trying to assign an expression of the wrong type"
typecheckStatement _ (Incr ident) = do
    vType <- lookupVariable ident
    case vType of
        Int -> return (Incr ident)
        vt -> throwE $ "Can only increment variables of type Int, found type" ++ show vt
typecheckStatement _ (Decr ident) = do
    vType <- lookupVariable ident
    case vType of
        Int -> return (Decr ident)
        vt -> throwE $ "Can only decrement variables of type Int, found type" ++ show vt
typecheckStatement rType (Ret expr) = do
    checkedExpr <- typecheckExpression expr
    exprType <- extractType checkedExpr
    if exprType == rType then
        return (Ret checkedExpr)
    else
        throwE $ "Function should return a " ++ show rType ++ " but return called with a " ++ show exprType
typecheckStatement rType VRet = case rType of
    Void -> return VRet
    _ -> throwE "Return without expression in non void function"
typecheckStatement rType (Cond expr stm) = do
    checkedExpr <- typecheckExpression expr
    checkedStm <- typecheckStatement rType stm
    return (Cond checkedExpr checkedStm)
typecheckStatement rType (CondElse expr stm1 stm2) = do
    checkedExpr <- typecheckExpression expr
    checkedStm1 <- typecheckStatement rType stm1
    checkedStm2 <- typecheckStatement rType stm2
    return (CondElse checkedExpr checkedStm1 checkedStm2)
typecheckStatement rType (While expr stmt) = do
    checkedExpr <- typecheckExpression expr
    exprType <- extractType checkedExpr
    if exprType /= Bool then 
        throwE "Expression in while has to be boolean"
    else do
        checkedStm <- typecheckStatement rType stmt
        return (While checkedExpr checkedStm)
typecheckStatement rType (For itType itIdent arr stmt) = do
    old_state <- lift get
    let forState = Map.fromList [(itIdent, itType)]
    lift $ put $ forState:old_state
    checkedExpr <- typecheckExpression arr
    exprType <- extractType checkedExpr
    if not $ isArrayType exprType then
        throwE "Expression in For has to be an array"
    else do
        elemType <- elementType exprType
        if elemType /= itType then
            throwE "Missmatch between array type and declared iterator variable"
        else do
            checkedStm <- typecheckStatement rType stmt
            -- Restore old state
            lift $ put old_state
            return (For itType itIdent checkedExpr checkedStm)
typecheckStatement _ (SExp expr) = do
    checkedExpr <- typecheckExpression expr
    exprType <- extractType checkedExpr
    if exprType == Void then
        return (SExp checkedExpr)
    else
        throwE "Only void expressions allowed as statements"

typecheckDeclaration :: Type -> Item -> TCExceptRWS Item
typecheckDeclaration Void _ = throwE "Can't declare a variable of type void"
typecheckDeclaration dType (NoInitVar ident) = do
    typecheckDeclaration' dType ident
    return (NoInitVar ident)
typecheckDeclaration dType (Init ident expr) = do
    checkedExp <- typecheckExpression expr
    exprType <- extractType checkedExp
    if exprType == dType then do
        typecheckDeclaration' dType ident
        return (Init ident checkedExp)
    else
        throwE "Trying assign wrong type in declaration"

typecheckDeclaration' :: Type -> Ident -> TCExceptRWS ()
typecheckDeclaration' dType ident = do
    cstate <- lift get
    -- head is fine here since there is always at least one map 
    let scope = head cstate
    -- If it is a user defined type, check that it actually exists
    deSugardType <- case dType of
        DefType tdIdent -> do
            getTDType tdIdent
        _ -> return dType
    case Map.lookup ident scope of
        Just _ -> throwE ("Variable " ++ show ident ++ " defined multiple times in the same scope")
        Nothing -> do
            let new_scope = Map.insert ident deSugardType scope
            lift $ put (new_scope: tail cstate)

typecheckExpression :: Expr -> TCExceptRWS Expr
typecheckExpression (ETyped _ _) = throwE "INTERNAL ERROR: ETyped encountred while typechecking, meaning the typechecker has traversed this tree before"
typecheckExpression e@(EVar ident) = do
    vType <- lookupVariable ident
    return $ ETyped vType e
typecheckExpression (EIndex aExpr iExpr) = do
    checkedAExpr <- typecheckExpression aExpr
    aType <- extractType checkedAExpr
    eType <- elementType aType
    checkedIExpr <- typecheckExpression iExpr
    iType <- extractType checkedIExpr
    case iType of
      Int -> return $ ETyped eType (EIndex checkedAExpr checkedIExpr)
      t -> throwE $ "index has to be an integer, " ++ show t ++ " found"

typecheckExpression e@(ELitInt _) = return $ ETyped Int e

typecheckExpression e@(ELitDoub _) = return $ ETyped Doub e

typecheckExpression ELitTrue = return $ ETyped Bool ELitTrue
typecheckExpression ELitFalse = return $ ETyped Bool ELitFalse
typecheckExpression (EApp ident args) = do
    (rType, checkedArgs) <- checkFunCall ident args
    return $ ETyped rType $ EApp ident checkedArgs
-- String literals are handeled separatly so we never get here
typecheckExpression (EString _) = throwE "INTERNAL ERROR: String in general expression"
typecheckExpression (Neg subex) = do
    checkedSubex <- typecheckExpression subex
    subexType <- extractType checkedSubex
    case subexType of
      Int -> return $ ETyped Int (Neg checkedSubex)
      Doub -> return $ ETyped Doub (Neg checkedSubex)
      _ -> throwE "Negation is only defined for Int and Double"
typecheckExpression (Not subex) = do
    checkedSubex <- typecheckExpression subex
    subexType <- extractType checkedSubex
    case subexType of
      Bool -> return $ ETyped Bool (Not checkedSubex)
      _ -> throwE "Not is only defined for booleans"
typecheckExpression (EMul e1 Mod e2) = do
    checkedE1 <- typecheckExpression e1
    e1Type <- extractType checkedE1
    checkedE2 <- typecheckExpression e2
    e2Type <- extractType checkedE2
    if e1Type /= e2Type then
        throwE "left and right expressions in Mod are different types"
    else
        case e1Type of
            Int -> return $ ETyped Int $ EMul checkedE1 Mod checkedE2
            _ -> throwE "Modulus is only defined for integers"
typecheckExpression (EMul e1 op e2) = do
    checkedE1 <- typecheckExpression e1
    e1Type <- extractType checkedE1
    checkedE2 <- typecheckExpression e2
    e2Type <- extractType checkedE2
    if e1Type /= e2Type then
        throwE "left and right expressions in mul op are different types"
    else
        case e1Type of
            Int -> return $ ETyped Int $ EMul checkedE1 op checkedE2
            Doub -> return $ ETyped Doub $ EMul checkedE1 op checkedE2
            _ -> throwE "Mul is only defined for integers and doubles"
typecheckExpression (EAdd e1 op e2) = do
    checkedE1 <- typecheckExpression e1
    e1Type <- extractType checkedE1
    checkedE2 <- typecheckExpression e2
    e2Type <- extractType checkedE2
    if e1Type /= e2Type then
        throwE "left and right expressions in add op are different types"
    else
        case e1Type of
            Int -> return $ ETyped Int $ EAdd checkedE1 op checkedE2
            Doub -> return $ ETyped Doub $ EAdd checkedE1 op checkedE2
            _ -> throwE "add is only defined for integers and doubles"
typecheckExpression (ERel e1 op e2) = do
    checkedExp1 <- typecheckExpression e1
    e1Type <- extractType checkedExp1
    checkedExp2 <- typecheckExpression e2
    e2Type <- extractType checkedExp2
    if e1Type /= e2Type then
        throwE "left and right expressions in rel op are different types"
    else
        case e1Type of
            Int -> return $ ETyped Bool $ ERel checkedExp1 op checkedExp2
            Doub -> return $ ETyped Bool $ ERel checkedExp1 op checkedExp2
            Bool -> return $ ETyped Bool $ ERel checkedExp1 op checkedExp2
            _ -> throwE "relation is only defined for integers and doubles"
typecheckExpression (EAnd e1 e2) = do
    checkedE1 <- typecheckExpression e1
    e1Type <- extractType checkedE1
    checkedE2 <- typecheckExpression e2
    e2Type <- extractType checkedE2
    if e1Type == Bool && e2Type == Bool then
        return $ ETyped Bool $ EAnd checkedE1 checkedE2
    else 
        throwE "And is only defined for booleans"
typecheckExpression (EOr e1 e2) = do
    checkedE1 <- typecheckExpression e1
    e1Type <- extractType checkedE1
    checkedE2 <- typecheckExpression e2
    e2Type <- extractType checkedE2
    if e1Type == Bool && e2Type == Bool then
        return $ ETyped Bool $ EOr checkedE1 checkedE2
    else 
        throwE "Or is only defined for booleans"
typecheckExpression (ENew (NewArray aType sExpr)) = do
    checkedExpr <- typecheckExpression sExpr
    exprType <- extractType checkedExpr
    if exprType == Int then
        return $ ETyped (Array aType) (ENew (NewArray aType checkedExpr))
    else 
        throwE $ "Size of array must be an int, " ++ show exprType ++ " found"
typecheckExpression (ENew (NewStruct sType)) = throwE "Not Implemented"

typecheckExpression (EDeref ptrExpr ident) = throwE "Not Impplemented"

--
typecheckExpression e@(ESelect aExpr (Ident "length")) = do
    checkedAExpr <- typecheckExpression aExpr
    aType <- extractType checkedAExpr
    if isArrayType aType then
        return $ ETyped Int (ESelect checkedAExpr (Ident "length"))
    else
        throwE $ show e ++ " is not an array type!"
typecheckExpression (ESelect sExpr ident) = throwE "Not implemented"

isArrayType :: Type -> Bool
isArrayType t = t `elem` arrayTypes

elementType :: Type -> TCExceptRWS Type
elementType (Array eType) = return eType
elementType typ = throwE $ "elementType called on " ++ show typ

extractType :: Expr -> TCExceptRWS Type
extractType (ETyped t _) = return t 
extractType _ = throwE "extractType called on non ETyped"

-- Backport of tryE since it is not in this version of transformers
tryE :: Monad m => ExceptT e m a -> ExceptT e m (Either e a)
tryE m = catchE (liftM Right m) (return . Left)

types :: [Type]
types = [Void] ++ baseTypes ++ arrayTypes

baseTypes :: [Type]
baseTypes = [Int, Doub, Bool]

arrayTypes :: [Type]
arrayTypes = map Array baseTypes

getAllUserTypes :: TCExceptRWS [Type]
getAllUserTypes = do
    symbols <- lift ask
    let keys = Map.keys (typeDefs symbols)
    return $ map DefType keys

checkFunCall :: Ident -> [Expr] -> TCExceptRWS (Type, [Expr])
-- printString needs special handeling since String is not a type in Javalette
checkFunCall (Ident "printString") expr@[EString _] = return (Void, expr)
checkFunCall (Ident "printString") _ = throwE "printString called wrong"
checkFunCall fIdent args = do
    (FunctionSig rType argTypes) <- getFunSig fIdent
    if length args /= length argTypes then
        throwE $ "Function " ++ show fIdent ++ " called with " ++ show (length args) ++ " when it takes " ++ show (length argTypes)
    else do
        checkedArgs <- mapM typecheckExpression args
        providedArgTypes <- mapM extractType checkedArgs
        if providedArgTypes == argTypes then
            return (rType, checkedArgs)
        else
            throwE "Function called with wrong argument types!"



getFunSig :: Ident -> TCExceptRWS FunctionSig
getFunSig fIdent = do
    symbols <- lift ask
    case Map.lookup fIdent (functions symbols) of
        Nothing -> throwE ("Call to undeclared function " ++ show fIdent)
        Just fsig -> return fsig

getTDType :: TDef -> TCExceptRWS Type
getTDType tdIdent = do
    symbols <- lift ask
    case Map.lookup tdIdent (typeDefs symbols) of
        Nothing -> throwE ("Reference to non declared type " ++ show tdIdent)
        Just td -> return (DefType td)
getStruct :: Ident -> TCExceptRWS Structure
getStruct structIdent = do
    symbols <- lift ask
    case Map.lookup structIdent (structs symbols) of
        Nothing -> throwE ("Reference to non declared type " ++ show structIdent)
        Just fsig -> return fsig

-- Checks if all paths of a program return. Notably does not check type of the return or for situations like
-- if True return
allPathsReturn :: [Stmt] -> Bool
allPathsReturn [] = False
allPathsReturn ((Ret _):_) = True
allPathsReturn ((CondElse _ stm1 stm2):ss) = bothReturns || allPathsReturn ss
    where
        bothReturns = allPathsReturn [stm1] && allPathsReturn [stm2]
allPathsReturn ((BStmt (Block bstms)):ss) = allPathsReturn bstms || allPathsReturn ss
allPathsReturn (_:ss) = allPathsReturn ss


lookupVariable :: Ident -> TCExceptRWS Type
lookupVariable ident = do
    cstate <- lift get
    case lookupVariable' ident cstate of
        Nothing -> throwE ("Use of undeclared variable " ++ show ident)
        Just vType -> return vType


lookupVariable' :: Ident -> [Map.Map Ident Type] -> Maybe Type
lookupVariable' _ [] = Nothing
lookupVariable' ident (m:ms) =
    case Map.lookup ident m of
        Just t  -> Just t
        Nothing -> lookupVariable' ident ms