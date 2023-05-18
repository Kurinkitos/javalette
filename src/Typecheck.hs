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
    lType <- inferType lExpr
    checkedLExpr <- typecheckExpression lType lExpr
    checkedAssExpr <- typecheckExpression lType assExpr
    return $ Ass checkedLExpr checkedAssExpr
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
    checkedExpr <- typecheckExpression rType expr
    return (Ret checkedExpr)
typecheckStatement rType VRet = case rType of
    Void -> return VRet
    _ -> throwE "Return without expression in non void function"
typecheckStatement rType (Cond expr stm) = do
    checkedExpr <- typecheckExpression Bool expr
    checkedStm <- typecheckStatement rType stm
    return (Cond checkedExpr checkedStm)
typecheckStatement rType (CondElse expr stm1 stm2) = do
    checkedExpr <- typecheckExpression Bool expr
    checkedStm1 <- typecheckStatement rType stm1
    checkedStm2 <- typecheckStatement rType stm2
    return (CondElse checkedExpr checkedStm1 checkedStm2)
typecheckStatement rType (While expr stmt) = do
    checkedExpr <- typecheckExpression Bool expr
    checkedStm <- typecheckStatement rType stmt
    return (While checkedExpr checkedStm)
typecheckStatement rType (For itType itIdent arr stmt) = do
    old_state <- lift get
    let forState = Map.fromList [(itIdent, itType)]
    lift $ put $ forState:old_state
    checkedExpr <- typecheckExpression (Array itType) arr
    checkedStm <- typecheckStatement rType stmt
    -- Restore old state
    lift $ put old_state
    return (For itType itIdent checkedExpr checkedStm)
typecheckStatement _ (SExp expr) = do
    checkedExpr <- typecheckExpression Void expr
    return (SExp checkedExpr)

typecheckDeclaration :: Type -> Item -> TCExceptRWS Item
typecheckDeclaration Void _ = throwE "Can't declare a variable of type void"
typecheckDeclaration dType (NoInitVar ident) = do
    typecheckDeclaration' dType ident
    return (NoInitVar ident)
typecheckDeclaration dType (Init ident expr) = do
    checkedExp <- typecheckExpression dType expr
    typecheckDeclaration' dType ident
    return (Init ident checkedExp)

typecheckDeclaration' :: Type -> Ident -> TCExceptRWS ()
typecheckDeclaration' dType ident = do
    cstate <- lift get
    -- head is fine here since there is always at least one map TODO: Refactor with NonEmpty
    let scope = head cstate
    case Map.lookup ident scope of
        Just _ -> throwE ("Variable " ++ show ident ++ " defined multiple times in the same scope")
        Nothing -> do
            let new_scope = Map.insert ident dType scope
            lift $ put (new_scope: tail cstate)

typecheckExpression :: Type -> Expr -> TCExceptRWS Expr
typecheckExpression _ (ETyped _ _) = throwE "INTERNAL ERROR: ETyped encountred while typechecking, meaning the typechecker has traversed this tree before"
typecheckExpression eType e@(EVar ident) = do
    vType <- lookupVariable ident
    if vType == eType then
        return $ ETyped eType e
    else
        throwE $ show eType ++ " expected, but " ++ show ident ++ " is of type " ++ show vType
typecheckExpression eType (EIndex aExpr iExpr) = do
    checkedAExpr <- typecheckExpression (Array eType) aExpr
    checkedIExpr <- typecheckExpression Int iExpr
    return $ ETyped eType (EIndex checkedAExpr checkedIExpr)

typecheckExpression Int e@(ELitInt _) = return $ ETyped Int e
typecheckExpression eType (ELitInt _) = throwE $ "Int expected, found: " ++ show eType

typecheckExpression Doub e@(ELitDoub _) = return $ ETyped Doub e
typecheckExpression eType (ELitDoub _) = throwE $ "Double expected, found: " ++ show eType

typecheckExpression Bool ELitTrue = return $ ETyped Bool ELitTrue
typecheckExpression eType ELitTrue = throwE $ "Boolean expected, found: " ++ show eType
typecheckExpression Bool ELitFalse = return $ ETyped Bool ELitFalse
typecheckExpression eType ELitFalse = throwE $ "Boolean expected, found: " ++ show eType
typecheckExpression eType (EApp ident args) = do
    checkedArgs <- checkFunCall eType ident args
    return $ ETyped eType $ EApp ident checkedArgs
-- String literals are handeled separatly so we never get here
typecheckExpression _ (EString _) = throwE "INTERNAL ERROR: String in general expression"
typecheckExpression eType (Neg subex) = do
    checkedSubex <- typecheckExpression eType subex
    return $ ETyped eType (Neg checkedSubex)
typecheckExpression Bool (Not subex) = do
    checkedSubex <- typecheckExpression Bool subex
    return $ ETyped Bool (Not checkedSubex)
typecheckExpression eType (Not _) = throwE $ "Boolean expected, found: " ++ show eType
-- Special case for Mod since it is only defined for Ints
typecheckExpression Int (EMul e1 Mod e2) = do
    checkedE1 <- typecheckExpression Int e1
    checkedE2 <- typecheckExpression Int e2
    return $ ETyped Int $ EMul checkedE1 Mod checkedE2
typecheckExpression eType (EMul _ Mod _) = throwE $ "Integer expected, found " ++ show eType
typecheckExpression Bool (EMul {}) = throwE "Multiplication not defined for Bool"
typecheckExpression eType (EMul e1 op e2) = do
    checkedE1 <- typecheckExpression eType e1
    checkedE2 <- typecheckExpression eType e2
    return $ ETyped eType $ EMul checkedE1 op checkedE2
typecheckExpression Bool (EAdd {}) = throwE "Addition not defined for Bool"
typecheckExpression eType (EAdd e1 op e2) = do
    checkedE1 <- typecheckExpression eType e1
    checkedE2 <- typecheckExpression eType e2
    return $ ETyped eType $ EAdd checkedE1 op checkedE2
-- Since the types of e1 and e2 are not known yet, have to try both int and double
typecheckExpression Bool (ERel e1 op e2) = do
    t <- inferType e1
    checkedExp1 <- typecheckExpression t e1
    checkedExp2 <- typecheckExpression t e2
    return $ ETyped Bool (ERel checkedExp1 op checkedExp2)
typecheckExpression eType (ERel {}) = throwE $ show eType ++ " expected, found bool"
typecheckExpression Bool (EAnd e1 e2) = do
    checkedE1 <- typecheckExpression Bool e1
    checkedE2 <- typecheckExpression Bool e2
    return $ ETyped Bool $ EAnd checkedE1 checkedE2
typecheckExpression eType (EAnd _ _) = throwE $ "And is defined for bools, not " ++ show eType
typecheckExpression Bool (EOr e1 e2) = do
    checkedE1 <- typecheckExpression Bool e1
    checkedE2 <- typecheckExpression Bool e2
    return $ ETyped Bool $ EOr checkedE1 checkedE2
typecheckExpression eType (EOr _ _) = throwE $ "Or is defined for bools, not " ++ show eType
typecheckExpression eType (ENew (NewArray aType sExpr)) =
    if Array aType == eType then do
        checkedExpr <- typecheckExpression Int sExpr
        return $ ETyped (Array aType) (ENew (NewArray aType checkedExpr))
    else do
        throwE $ "Trying to assign a new array of " ++ show aType ++ "s to variable of type " ++ show eType
typecheckExpression eType (ENew (NewStruct sType)) = undefined

typecheckExpression eType (EDeref ptrExpr ident) = undefined

--
typecheckExpression Int e@(ESelect aExpr (Ident "length")) = do
    aType <- inferType aExpr
    checkedAExpr <- typecheckExpression aType aExpr
    if isArrayType aType then
        return $ ETyped Int (ESelect checkedAExpr (Ident "length"))
    else
        throwE $ show e ++ " is not an array type!"
typecheckExpression eType (ESelect sExpr ident) = throwE "Not implemented"

isArrayType :: Type -> Bool
isArrayType t = t `elem` arrayTypes

elementType :: Type -> TCExceptRWS Type
elementType (Array eType) = return eType
elementType typ = throwE $ "elementType called on " ++ show typ

-- This function is a workaround for how I made the typecheckExpression function, 
-- it is very slow compared to real type inference since it just tries all types instead
inferType :: Expr -> TCExceptRWS Type
inferType expr = do
    userTypes <- getAllUserTypes
    res <- mapM checkExpr (types ++ userTypes)
    case rights res of
        [] -> throwE $ "INTERNAL ERROR: No type matches that of expression " ++ show expr ++ " errors: " ++ unlines (map show (lefts res) )
        [ETyped t _] -> return t
        _ -> throwE $ "INTERNAL ERROR: Failed to infer type of expression " ++ show expr
    where
        checkExpr t = tryE $ typecheckExpression t expr

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

checkFunCall :: Type -> Ident -> [Expr] -> TCExceptRWS [Expr]
-- printString needs special handeling since String is not a type in Javalette
checkFunCall Void (Ident "printString") expr@[EString _] = return expr
checkFunCall _ (Ident "printString") _ = throwE "printString called wrong"
checkFunCall eType fIdent args = do
    (FunctionSig rType argTypes) <- getFunSig fIdent
    if length args /= length argTypes then
        throwE $ "Function " ++ show fIdent ++ " called with " ++ show (length args) ++ " when it takes " ++ show (length argTypes)
    else
        if eType /= rType then
            throwE $ show eType ++ " expected, but " ++ show fIdent ++ " returns " ++ show rType
        else
            zipWithM typecheckExpression argTypes args



getFunSig :: Ident -> TCExceptRWS FunctionSig
getFunSig fIdent = do
    symbols <- lift ask
    case Map.lookup fIdent (functions symbols) of
        Nothing -> throwE ("Call to undeclared function " ++ show fIdent)
        Just fsig -> return fsig

getTDType :: Ident -> TCExceptRWS TDef
getTDType tdIdent = do
    symbols <- lift ask
    case Map.lookup tdIdent (typeDefs symbols) of
        Nothing -> throwE ("Reference to non declared type " ++ show tdIdent)
        Just fsig -> return fsig
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