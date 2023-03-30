module Typecheck (
        typecheck
    ) where

import Javalette.Abs

import qualified Data.Map.Lazy as Map
import Data.List.Unique
import Control.Monad.RWS
import Control.Monad.Except
import Data.Either (lefts, rights)

-- The list of maps represents variables, forming a stack to permitt shadowing
data FunctionSig = FunctionSig Type [Type]
type SymbolsRWS = RWS (Map.Map Ident FunctionSig) () [Map.Map Ident Type]
type TCExcept = ExceptT String

typecheck :: Prog -> Either String Prog
typecheck (Program [])     = Left "No function definitions found"
typecheck prog@(Program topdefs) = case initFunctionSigs prog of
    Left err -> Left err
    Right fsigs -> case lefts checkedFuns of
        []  -> Right (Program (rights checkedFuns))
        ers -> Left (unlines ers)
        where
            checkedFuns = map (fst . checkFun) topdefs
            checkFun td = evalRWS (runExceptT (typecheckFunction td)) fsigs [functionArgTypes td]


functionArgTypes :: TopDef -> Map.Map Ident Type
functionArgTypes (FnDef _ _ args _) = Map.fromList (functionArgTypes' args)

functionArgTypes' :: [Arg] -> [(Ident, Type)]
functionArgTypes' [] = []
functionArgTypes' ((Argument t ident):as) = (ident, t) : functionArgTypes' as

initFunctionSigs :: Prog -> Either String (Map.Map Ident FunctionSig)
initFunctionSigs (Program defs) = case repeated fidents of
        [] -> Right (Map.fromList fsigs)
        (ident:_) -> Left ("Function " ++ show ident ++ " defined multiple times")
    where
        fsigs = initSymbols' defs
        fidents = map fst fsigs


initSymbols' :: [TopDef] -> [(Ident, FunctionSig)]
initSymbols' []     = []
initSymbols' ((FnDef retType ident args _):tds) = (ident, FunctionSig retType argTypes) : ss
    where
        argTypes = map argToType args
        ss = initSymbols' tds

argToType :: Arg -> Type
argToType (Argument t _) = t

-- I'm checking that the function returns separate from the main pass. 
-- It's a lot slower but simplifies the functions
typecheckFunction :: TopDef -> TCExcept SymbolsRWS TopDef
typecheckFunction topdef@(FnDef Void _id _args _blk) = typecheckFunction' topdef
typecheckFunction topdef@(FnDef _retType _id _args (Block stms)) = if allPathsReturn stms
    then typecheckFunction' topdef
    else throwError "Function is not guaranteed to return a value"


typecheckFunction' :: TopDef -> TCExcept SymbolsRWS TopDef
typecheckFunction' (FnDef retType ident args (Block stms)) = do
    FnDef retType ident args . Block <$> checkedStms
    where
        checkedStms = mapM (typecheckStatement retType) stms





typecheckStatement :: Type -> Stmt -> TCExcept SymbolsRWS Stmt
typecheckStatement _ Empty = return Empty
typecheckStatement retType (BStmt (Block stms)) = do
    checkedStms <- mapM (typecheckStatement retType) stms
    return (BStmt (Block checkedStms))
typecheckStatement _ (Decl vType decls) = do
    checkedDeclarations <- mapM (typecheckDeclaration vType) decls
    return (Decl vType checkedDeclarations)
typecheckStatement _ (Ass ident expr) = do
    vType <- lookupVariable ident
    checkedExpr <- typecheckExpression vType expr
    return (Ass ident checkedExpr)
typecheckStatement _ (Incr ident) = do
    vType <- lookupVariable ident
    case vType of
        Int -> return (Incr ident)
        vt -> throwError $ "Can only increment variables of type Int, found type" ++ show vt
typecheckStatement _ (Decr ident) = do
    vType <- lookupVariable ident
    case vType of
        Int -> return (Incr ident)
        vt -> throwError $ "Can only decrement variables of type Int, found type" ++ show vt
typecheckStatement rType (Ret expr) = do
    checkedExpr <- typecheckExpression rType expr
    return (Ret checkedExpr)
typecheckStatement rType VRet = case rType of
    Void -> return VRet
    _ -> throwError "Return without expression in non void function"
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
typecheckStatement _ (SExp expr) = do
    checkedExpr <- typecheckExpression Void expr
    return (SExp checkedExpr)


typecheckDeclaration :: Type -> Item -> TCExcept SymbolsRWS Item
typecheckDeclaration Void _ = throwError "Can't declare a variable of type void"
typecheckDeclaration dType (NoInit ident) = do
    typecheckDeclaration' dType ident
    return (NoInit ident)
typecheckDeclaration dType (Init ident expr) = do
    checkedExp <- typecheckExpression dType expr
    return (Init ident checkedExp)

typecheckDeclaration' :: Type -> Ident -> TCExcept SymbolsRWS ()
typecheckDeclaration' dType ident = do
    cstate <- get
    -- head is fine here since there is always at least one map TODO: Refactor with NonEmpty
    let scope = head cstate
    case Map.lookup ident scope of
        Just _ -> throwError ("Variable " ++ show ident ++ " defined multiple times in the same scope")
        Nothing -> do
            let new_scope = Map.insert ident dType scope
            put (new_scope: tail cstate)

typecheckExpression :: Type -> Expr -> TCExcept SymbolsRWS Expr
typecheckExpression _ (ETyped _ _) = throwError "INTERNAL ERROR: ETyped encountred while typechecking, meaning the typechecker has traversed this tree before"
typecheckExpression eType e@(EVar ident) = do
    vType <- lookupVariable ident
    if vType == eType then
        return $ ETyped eType e
    else
        throwError $ show eType ++ " expected, but " ++ show ident ++ " is of type " ++ show vType
typecheckExpression Int e@(ELitInt _) = return $ ETyped Int e
typecheckExpression eType (ELitInt _) = throwError $ "Int expected, found: " ++ show eType

typecheckExpression Doub e@(ELitDoub _) = return $ ETyped Doub e
typecheckExpression eType (ELitDoub _) = throwError $ "Double expected, found: " ++ show eType

typecheckExpression Bool ELitTrue = return $ ETyped Bool ELitTrue
typecheckExpression eType ELitTrue = throwError $ "Boolean expected, found: " ++ show eType
typecheckExpression Bool ELitFalse = return $ ETyped Bool ELitFalse
typecheckExpression eType ELitFalse = throwError $ "Boolean expected, found: " ++ show eType

typecheckExpression ex_type expr = return (ETyped ex_type expr)

checkFunCall :: Ident -> [Expr] -> TCExcept SymbolsRWS [Expr]
checkFunCall fIdent args = do
    (FunctionSig rType argTypes) <- getFunSig fIdent
    if length args /= length argTypes then
        throwError $ "Function " ++ show fIdent ++ " called with " ++ show (length args) ++ " when it takes " ++ show (length argTypes)
    else
        undefined

getFunSig :: Ident -> TCExcept SymbolsRWS FunctionSig
getFunSig fIdent = do
    sigs <- ask
    case Map.lookup fIdent sigs of
        Nothing -> throwError ("Call to undeclared function " ++ show fIdent)
        Just fsig -> return fsig

-- Checks if all paths of a program return. Notably does not check type of the return or for situations like
-- if True return
allPathsReturn :: [Stmt] -> Bool
allPathsReturn [] = False
allPathsReturn ((Ret _):_) = True
allPathsReturn ((CondElse _ stm1 stm2):ss) = bothReturns || allPathsReturn ss
    where
        bothReturns = allPathsReturn [stm1] && allPathsReturn [stm2]
allPathsReturn (_:ss) = allPathsReturn ss


lookupVariable :: Ident -> TCExcept SymbolsRWS Type
lookupVariable ident = do
    cstate <- get
    case lookupVariable' ident cstate of
        Nothing -> throwError ("Use of undeclared variable " ++ show ident)
        Just vType -> return vType


lookupVariable' :: Ident -> [Map.Map Ident Type] -> Maybe Type
lookupVariable' _ [] = Nothing
lookupVariable' ident (m:ms) =
    case Map.lookup ident m of
        Just t  -> Just t
        Nothing -> lookupVariable' ident ms