{-# LANGUAGE OverloadedStrings #-}
module LLVMBackend (
    compile
) where
import Javalette.Abs (Prog, Ident)
import qualified Data.Map as Map
import Typecheck (FunctionSig)

import LLVM.AST.Name


import Control.Monad.Trans.RWS
import LLVM.AST (Module (moduleDefinitions, moduleName), defaultModule)

type CodegenRWS = RWS (Map.Map Ident FunctionSig) () CodegenState
data CodegenState = CodegenState {
    counter :: Integer, -- Used for generating unique labes and register names
    stringLiterals :: Map.Map String Name, -- Map from string literals to LLVM global names
    variables :: [Map.Map Ident Name] -- Stack of maps from JL names to LLVM names, stack to keep track of shadowing
}
initialState :: CodegenState
initialState = CodegenState 0 Map.empty []

compile :: Prog -> Map.Map Ident FunctionSig -> String
compile program fsigs = show m
    where
        (m, _, _) = runRWS (codegen program) fsigs initialState


codegen :: Prog -> CodegenRWS Module
codegen program = return defaultModule {
    moduleName = "test",
    moduleDefinitions = []
}