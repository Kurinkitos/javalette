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
    , structs :: Map.Map Type Structure
    , typeDefs :: Map.Map Ident TDef
    }


typecheck :: Prog -> Either String (Prog, Symbols)
typecheck (Program [])     = Left "No function definitions found"
typecheck prog@(Program topdefs) = case initFunctionSigs prog of
    Left err -> Left err
    Right fsigs -> case initStructures prog of
        Left err -> Left err
        Right structSigs -> case lefts checkedTds of
            []  -> Right (Program (rights checkedTds), symbols)
            ers -> Left (unlines ers)
            where
                checkedTds = checkedFns ++ checkedTypeDefs ++ checkedStructs
                checkedFns = map (fst . checkFns) fnTds
                checkedTypeDefs = map (fst . checkTypeDef) typeDefTds
                checkedStructs = map (fst . checkStruct) structTds
                checkFns fn = evalRWS (runExceptT (typecheckFunction fn)) symbols []
                checkTypeDef td = evalRWS (runExceptT (typecheckTypeDef td)) symbols []
                checkStruct strc = evalRWS (runExceptT (typecheckStruct strc)) symbols []
                fnTds = [ fn | fn@FnDef {} <- topdefs]
                typeDefTds = [ td | td@TypeDef {} <- topdefs]
                structTds = [ strc | strc@StructDef {} <- topdefs]
                symbols = Symbols {
                    functions = fsigs,
                    structs = structSigs,
                    typeDefs = initTypeDefs prog
                }




initFunctionSigs :: Prog -> Either String (Map.Map Ident FunctionSig)
initFunctionSigs (Program defs) = case repeated fidents of
        [] -> case Map.lookup (Ident "main") funs of
            Nothing -> Left "No main function!"
            Just (FunctionSig Int []) -> Right funs
            Just _ -> Left "Main function has wrong signature!"
        (ident:_) -> Left ("Function " ++ show ident ++ " defined multiple times")
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

initStructures :: Prog -> Either String (Map.Map Type Structure)
initStructures (Program defs) = case repeated structIdents of
    [] -> Right (Map.fromList structList)
    (ident:_) -> Left ("Structure " ++ show ident ++ " defined multiple times")
    where
        structList = initStructures' defs
        structIdents = map fst structList

initStructures' :: [TopDef] -> [(Type, Structure)]
initStructures' [] = []
initStructures' ((StructDef ident mems):tds) = (Ptr ident, initStructMems mems) : initStructures' tds
    where
        initStructMems mms = Map.fromList (map initStructMem mms)
        initStructMem (Member mType mIdent) = (mIdent, mType)
initStructures' (_:tds) = initStructures' tds

initTypeDefs :: Prog -> Map.Map Ident TDef
initTypeDefs (Program tdefs) = Map.fromList (initTypeDefs' tdefs)

initTypeDefs' :: [TopDef] -> [(Ident, TDef)]
initTypeDefs' [] = []
initTypeDefs' ((TypeDef srcType newName):tds) = (newName, srcType) : initTypeDefs' tds
initTypeDefs' (_:tds) = initTypeDefs' tds


argToType :: Arg -> Type
argToType (Argument t _) = t

typecheckTypeDef :: TopDef -> TCExceptRWS TopDef
typecheckTypeDef td@(TypeDef srcType newName) = do
    baseType <- getTDType newName
    _structType <- getStruct baseType
    if baseType /= Ptr srcType then
        throwE "Internal error, typedef has wrong type in State"
    else
        return td
typecheckTypeDef _ = throwE "typecheckTypeDef called on non TypeDef"

typecheckStruct :: TopDef -> TCExceptRWS TopDef
typecheckStruct (StructDef sIdent mems) = do
    case repeated (map memIdent mems) of
        [] -> do
            dsMems <- mapM desugarMem mems
            return $ StructDef sIdent dsMems
        (ident:_) -> throwE $ "Member " ++ show ident ++ " defined multiple times"
typecheckStruct _ = throwE "typecheckStruct called on non Struct"

memIdent :: Mem -> Ident
memIdent (Member _ ident) = ident

desugarMem :: Mem -> TCExceptRWS Mem
desugarMem (Member t ident) = do
    dsType <- desugarType t
    return $ Member dsType ident

-- I'm checking that the function returns separate from the main pass. 
-- It's a lot slower but simplifies the functions
typecheckFunction :: TopDef -> TCExceptRWS TopDef
typecheckFunction topdef@(FnDef Void _id _args _blk) = do
    fixedTopdef <- implicitReturn topdef
    typecheckFunction' fixedTopdef
typecheckFunction (FnDef retType ident args (Block stms)) = if allPathsReturn stms
    then do
        dsRetType <- desugarType retType
        typecheckFunction' (FnDef dsRetType ident args (Block stms))
    else throwE "Function is not guaranteed to return a value"
typecheckFunction _ = throwE "typecheckFunction called on non function!"



typecheckFunction' :: TopDef -> TCExceptRWS TopDef
typecheckFunction' (FnDef retType ident args (Block stms)) = do
    if Void `elem` map argToType args then
            throwE "Void is not allowed as a argument type"
        else do
            dsArgs <- mapM desugarArg args
            let argMap = Map.fromList (functionArgTypes dsArgs)
            -- Push the arguments to the state
            lift (put [argMap])
            checkedStms <- mapM (typecheckStatement retType) stms
            return $ FnDef retType ident dsArgs (Block checkedStms)
typecheckFunction' _ = throwE "typecheckFunction' Called on non Function!"

functionArgTypes :: [Arg] -> [(Ident, Type)]
functionArgTypes [] = []
functionArgTypes ((Argument t ident):as) = (ident, t) : functionArgTypes as


desugarArg :: Arg -> TCExceptRWS Arg
desugarArg (Argument aType ident) = do
    dsAType <- desugarType aType
    return $ Argument dsAType ident

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
    dsVType <- desugarType vType
    checkedDeclarations <- mapM (typecheckDeclaration dsVType) decls
    return (Decl dsVType checkedDeclarations)
typecheckStatement _ (Ass lExpr assExpr) = do
    checkedLExpr <- typecheckExpression lExpr
    lType <- extractType checkedLExpr
    checkedAssExpr <- typecheckExpression assExpr
    assType <- extractType checkedAssExpr
    if lType == assType then
        return $ Ass checkedLExpr checkedAssExpr
    else
        throwE $ "Trying to assign an expression of type " ++ show assType ++ " to variable of " ++ show lType
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
    dsItType <- desugarType itType
    let forState = Map.fromList [(itIdent, dsItType)]
    lift $ put $ forState:old_state
    checkedExpr <- typecheckExpression arr
    exprType <- extractType checkedExpr
    if not $ isArrayType exprType then
        throwE "Expression in For has to be an array"
    else do
        elemType <- elementType exprType
        if elemType /= dsItType then
            throwE $ "elemType is" ++ show elemType ++ " while dsItType is " ++ show dsItType
        else do
            checkedStm <- typecheckStatement rType stmt
            -- Restore old state
            lift $ put old_state
            return (For dsItType itIdent checkedExpr checkedStm)
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
        throwE $ "In declaration, trying to assign " ++ show exprType ++ " to variable of type " ++ show dType

typecheckDeclaration' :: Type -> Ident -> TCExceptRWS ()
typecheckDeclaration' dType ident = do
    cstate <- lift get
    -- head is fine here since there is always at least one map 
    let scope = head cstate
    -- If it is a user defined type, check that it actually exists
    case Map.lookup ident scope of
        Just _ -> throwE ("Variable " ++ show ident ++ " defined multiple times in the same scope")
        Nothing -> do
            let new_scope = Map.insert ident dType scope
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
    dsRType <- desugarType rType
    return $ ETyped dsRType $ EApp ident checkedArgs
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
        throwE $ "left expr has type " ++ show e1Type ++ " and right has type " ++ show e2Type
    else
        case e1Type of
            Int -> return $ ETyped Bool $ ERel checkedExp1 op checkedExp2
            Doub -> return $ ETyped Bool $ ERel checkedExp1 op checkedExp2
            Bool -> return $ ETyped Bool $ ERel checkedExp1 op checkedExp2
            Ptr _t -> return $ ETyped Bool $ ERel checkedExp1 op checkedExp2
            t -> throwE $ "relation is not defined for " ++ show t
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
typecheckExpression ne@(ENew (NewStruct (DefType sIdent))) = do
    _struct <- getStruct (Ptr sIdent)
    return $ ETyped (Ptr sIdent) ne

typecheckExpression (ENew (NewStruct _)) = throwE "New used on non struct"

typecheckExpression (EDeref ptrExpr mIdent) = do
    checkedPtrExpr <- typecheckExpression ptrExpr
    ptrType <- extractType checkedPtrExpr
    case ptrType of
        structType@(Ptr _sIdent) -> do
            struct <- getStruct structType
            case Map.lookup mIdent struct of
                Nothing -> throwE $ "Struct does not have a member called" ++ show mIdent
                (Just memT) -> do
                    dsMemT <- desugarType memT
                    return $ ETyped dsMemT (EDeref checkedPtrExpr mIdent)
        t -> throwE $ "Trying to dereferece non pointer type " ++ show t


--
typecheckExpression (ESelect aExpr (Ident "length")) = do
    checkedAExpr <- typecheckExpression aExpr
    aType <- extractType checkedAExpr
    if isArrayType aType then
        return $ ETyped Int (ESelect checkedAExpr (Ident "length"))
    else
        throwE $ show aType ++ " is not an array type!"
typecheckExpression (ESelect _sExpr _ident) = throwE "Not implemented"

typecheckExpression (ENull t@(DefType _ptrName)) = do
    dsType <- desugarType t
    return $ ETyped dsType (ENull dsType)
typecheckExpression (ENull t ) = throwE $ "Null of non pointer type " ++ show t

isArrayType :: Type -> Bool
isArrayType (Array _) = True
isArrayType _ = False

elementType :: Type -> TCExceptRWS Type
elementType (Array eType) = return eType
elementType typ = throwE $ "elementType called on " ++ show typ

extractType :: Expr -> TCExceptRWS Type
extractType (ETyped t _) = desugarType t
extractType _ = throwE "extractType called on non ETyped"

-- Backport of tryE since it is not in this version of transformers
tryE :: Monad m => ExceptT e m a -> ExceptT e m (Either e a)
tryE m = catchE (liftM Right m) (return . Left)

desugarType :: Type -> TCExceptRWS Type
desugarType (DefType ident) = do
    tdBase <- tryE $ getTDType ident
    case tdBase of
      Left _s -> do
        -- This branch means we should have a struct type
        _struct <- getStruct (Ptr ident)
        return (Ptr ident)
      Right ty -> return ty
desugarType (Array elemType) = do
    dsElemType <- desugarType elemType
    return (Array dsElemType)
desugarType t = return t

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
        dsArgTypes <- mapM desugarType argTypes
        if providedArgTypes == dsArgTypes then
            return (rType, checkedArgs)
        else
            throwE $ "Function called with wrong argument types! Expected " ++ show dsArgTypes ++ " got " ++ show providedArgTypes


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
        Nothing -> throwE ("Reference to non declared def type " ++ show tdIdent)
        Just td -> return (Ptr td)
getStruct :: Type -> TCExceptRWS Structure
getStruct structType@(Ptr _ident) = do
    symbols <- lift ask
    case Map.lookup structType (structs symbols) of
        Nothing -> throwE ("Reference to non declared struct " ++ show structType)
        Just struct -> return struct
getStruct t = throwE $ "getStruct called on non pointer type " ++ show t

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