module Typecheck (
        typecheck
    ) where

import Javalette.Abs

import Data.Map (Map, lookup, fromList)
import Data.List.Unique
import Control.Monad.RWS
import Data.Either (lefts, rights)

-- The list of maps represents variables, forming a stack to permitt shadowing
data FunctionSig = FunctionSig Type [Type]
type SymbolsRWS = RWS (Map Ident FunctionSig) () [Map Ident Type]

typecheck :: Prog -> Either String Prog
typecheck (Program [])     = Left "No function definitions found"
typecheck prog@(Program topdefs) = case initFunctionSigs prog of
    Left err -> Left err
    Right fsigs -> case lefts checkedFuns of
        []  -> Right (Program (rights checkedFuns))
        ers -> Left (unlines ers)
        where
            checkedFuns = map (fst . checkFun) topdefs
            checkFun td = evalRWS (typecheckFunction td) fsigs [functionArgTypes td]

functionArgTypes :: TopDef -> Map Ident Type
functionArgTypes (FnDef _ _ args _) = Data.Map.fromList (functionArgTypes' args)

functionArgTypes' :: [Arg] -> [(Ident, Type)]
functionArgTypes' [] = []
functionArgTypes' ((Argument t ident):as) = (ident, t) : functionArgTypes' as

initFunctionSigs :: Prog -> Either String (Map Ident FunctionSig)
initFunctionSigs (Program defs) = case repeated fidents of
        [] -> Right (Data.Map.fromList fsigs)
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
typecheckFunction :: TopDef -> SymbolsRWS (Either String TopDef)
typecheckFunction topdef@(FnDef Void _id args stms) = return (Right topdef)
typecheckFunction (FnDef retType _id args (Block stms)) = case allPathsReturn stms of
    False -> return (Left "Function is not guaranteed to return a value")
    True -> undefined

-- Checks if all paths of a program return. Notably does not check type of the return or for situations like
-- if True return
allPathsReturn :: [Stmt] -> Bool
allPathsReturn [] = False
allPathsReturn ((Ret _):ss) = True
allPathsReturn ((CondElse _ stm1 stm2):ss) = bothReturns || allPathsReturn ss
    where
        bothReturns = allPathsReturn [stm1] && allPathsReturn [stm1]
allPathsReturn (_:ss) = allPathsReturn ss


lookupVariable :: Ident -> [Map Ident Type] -> Maybe Type
lookupVariable _ [] = Nothing
lookupVariable ident (m:ms) =
    case Data.Map.lookup ident m of
        Just t  -> Just t
        Nothing -> lookupVariable ident ms