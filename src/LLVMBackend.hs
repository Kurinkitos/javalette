{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
{-# OPTIONS_GHC -Wno-incomplete-record-updates #-}
module LLVMBackend (
    compile
) where
import Javalette.Abs
import qualified Data.Map as Map
import Typecheck (FunctionSig)
import Data.Text.Lazy (unpack)

import Data.ByteString as BS hiding (map)
import Data.ByteString.Short as BSS
import Data.ByteString.Char8 as BSC hiding (map)

import LLVM.AST hiding (function)

import LLVM.Pretty

import Control.Monad.Trans.State
import LLVM.IRBuilder.Module
import LLVM.IRBuilder.Monad
import LLVM.IRBuilder.Instruction
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import LLVM.IRBuilder (globalStringPtr)


compile :: Prog -> Map.Map Ident FunctionSig -> String
compile program fsigs = Data.Text.Lazy.unpack $ ppllvm m
    where
        m = codegen program fsigs

type CgMonad a = CgStateT (IRBuilderT ModuleBuilder) a
-- Stack of Maps from JL identifiers to LLVM names
type CgStateT = StateT [Map.Map Ident Operand]

codegen :: Prog -> Map.Map Ident FunctionSig -> Module
codegen (Program tds) fsigs = buildModule "Javalette" $ mapM cgFun tds

cgFun :: TopDef -> ModuleBuilder Operand
cgFun (FnDef retType fIdent fnArgs (Block stms)) = mdo
    let argIds = map argToIdent fnArgs
    let fnBody o = evalStateT (cgFnBody stms argIds o) [Map.empty]
    function
        (identToName fIdent)
        (encodeArgs fnArgs)
        (encodeType retType)
        fnBody

argToIdent :: Arg -> Ident
argToIdent (Argument _ ident) = ident

cgFnBody :: [Stmt] -> [Ident] -> [Operand] -> CgMonad ()
cgFnBody stms idents oprs = mdo
    _entry <- block
    pushArguments $ Prelude.zip idents oprs
    _ <- mapM cgStm stms
    return ()

pushArguments :: [(Ident, Operand)] -> CgMonad ()
pushArguments arg = put [Map.fromList arg]

cgStm :: Stmt -> CgStateT (IRBuilderT ModuleBuilder) ()
cgStm Empty = return ()
cgStm (BStmt (Block stms)) = undefined
cgStm (Decl vType decls) = undefined
cgStm (Ass ident expr) = undefined
cgStm (Incr ident) = undefined
cgStm (Decr ident) = undefined
cgStm (Javalette.Abs.Ret expr) = undefined
cgStm VRet = retVoid
cgStm (Cond expr stms) = undefined
cgStm (CondElse expr tStms fStms) = undefined
cgStm (While expr stms) = undefined
cgStm (SExp expr) = undefined

cgExpr :: Expr -> IRBuilderT ModuleBuilder Operand
cgExpr (ETyped eType expr) = case expr of
    ETyped _ _ -> error $ "Malformed AST! Nested ETyped found"
    EVar ident -> undefined
    ELitInt i -> return $ ConstantOperand (C.Int 32 i)
    ELitDoub d -> return $ ConstantOperand (C.Float (F.Double d))
    ELitTrue -> return $ ConstantOperand (C.Int 1 1)
    ELitFalse -> return $ ConstantOperand (C.Int 1 0)
    EApp fIdent exprs -> undefined
    EString str -> mdo
        strptr <- globalStringPtr str (mkName str)
        return $ ConstantOperand strptr
    Neg expr -> undefined
    Not expr -> undefined
    EMul expr1 mulop expr2 -> undefined
    EAdd expr1 addop expr2 -> undefined
    ERel expr1 relop expr2 -> undefined
    EAnd expr1 expr2 -> undefined
    EOr expr1 expr2 -> undefined
cgExpr expr = error $ "Malformed AST! Expected eType, found " ++ show expr

identToName :: Ident -> Name
identToName (Ident str) = mkName str
identToParName :: Ident -> ParameterName
identToParName (Ident idStr) = ParameterName $ BSS.toShort $ BSC.pack idStr

encodeType :: Javalette.Abs.Type -> LLVM.AST.Type
encodeType Int = IntegerType 32
encodeType Doub = FloatingPointType DoubleFP
encodeType Bool = IntegerType 1
encodeType Void = VoidType
encodeType (Fun retType args) = undefined --Should not happen, since we don't have function pointers

encodeArgs :: [Arg] -> [(LLVM.AST.Type, ParameterName)]
encodeArgs = map encodeArg

encodeArg :: Arg -> (LLVM.AST.Type, ParameterName)
encodeArg (Argument aType ident) = (encodeType aType, identToParName ident)

