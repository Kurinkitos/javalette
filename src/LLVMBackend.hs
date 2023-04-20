{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
{-# OPTIONS_GHC -Wno-incomplete-record-updates #-}
module LLVMBackend (
    compile
) where
import Javalette.Abs
import qualified Data.Map as Map
import Typecheck (FunctionSig (FunctionSig))
import Data.Text.Lazy (unpack)

import Data.ByteString as BS hiding (map)
import Data.ByteString.Short as BSS
import Data.ByteString.Char8 as BSC hiding (tail, map)

import LLVM.AST hiding (function)
import LLVM.AST.AddrSpace

import LLVM.Pretty

import LLVM.IRBuilder.Module
import LLVM.IRBuilder.Monad
import LLVM.IRBuilder.Instruction
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import Control.Monad.Trans.RWS
import LLVM.AST.Attribute (ParameterAttribute)
import LLVM.AST.FloatingPointPredicate (FloatingPointPredicate (OLT, OLE, OGT, OGE, OEQ, ONE))
import LLVM.AST.IntegerPredicate (IntegerPredicate (SLT, SLE, SGT, SGE, EQ, NE))


compile :: Prog -> Map.Map Ident FunctionSig -> String
compile program fsigs = Data.Text.Lazy.unpack $ ppllvm m
    where
        m = codegen program fsigs

type CgMonad a = CgRSWT (IRBuilderT ModuleBuilder) a
-- Stack of Maps from JL identifiers to LLVM names
type CgRSWT = RWST (Map.Map Ident Operand) () [Map.Map Ident Operand]

codegen :: Prog -> Map.Map Ident FunctionSig -> Module
codegen (Program tds) fsigs = buildModule "Javalette" $ mdo
    builtIns <- cgBuiltinDefs
    fndefs <- pushFnDefs (Map.toList fsigs)
    mapM (cgFun (Map.fromList (builtIns ++ fndefs))) tds

cgBuiltinDefs :: ModuleBuilder [(Ident, Operand)]
cgBuiltinDefs = mdo
    printIntPtr <- extern "printInt" [encodeType Int] (encodeType Void)
    printDoublePtr <- extern "printDouble" [encodeType Doub] (encodeType Void)
    printStringPtr <- extern "printString" [PointerType (IntegerType 8) (AddrSpace 0)] (encodeType Void)
    readIntPtr <- extern "readInt" [] (encodeType Int)
    readDoublePtr <- extern "readDouble" [] (encodeType Doub)
    return
        [ (Ident "printInt", printIntPtr)
        , (Ident "printDouble", printDoublePtr)
        , (Ident "printString", printStringPtr)
        , (Ident "readInt", readIntPtr)
        , (Ident "readDouble", readDoublePtr)
        ]

pushFnDefs :: [(Ident, FunctionSig)] -> ModuleBuilder [(Ident, Operand)]
pushFnDefs = mapM pushFnDef
pushFnDef :: (Ident, FunctionSig) -> ModuleBuilder (Ident, Operand)
pushFnDef (ident@(Ident str), FunctionSig rType fArgs) = return (ident, fnOpr)
    where
        fnOpr = ConstantOperand fnRef
        fnRef = C.GlobalReference fnType (mkName str)
        fnType = FunctionType (encodeType rType) (map encodeType fArgs) False

cgFun :: Map.Map Ident Operand -> TopDef -> ModuleBuilder Operand
cgFun fsigs (FnDef retType fIdent fnArgs (Block stms)) = mdo
    function
        (identToName fIdent)
        (encodeArgs fnArgs)
        (encodeType retType)
        fnBody
    where
        fnBody o = mdo
            _unit <- evalRWST (cgFnBody stms fnArgs o) fsigs [Map.empty]
            return ()



argToIdent :: Arg -> Ident
argToIdent (Argument _ ident) = ident

cgFnBody :: [Stmt] -> [Arg] -> [Operand] -> CgMonad ()
cgFnBody stms idents oprs = mdo
    _entry <- block
    pushArguments $ Prelude.zip idents oprs
    _ <- mapM cgStm stms
    return ()

pushArguments :: [(Ident, Operand)] -> CgMonad ()
pushArguments arg = mdo 
    put [Map.fromList arg]


cgDecl :: Javalette.Abs.Type -> Item -> CgMonad ()
cgDecl vType (NoInit ident) = mdo
    _vOp <- cgDecl' vType ident
    return ()
cgDecl vType (Init ident expr) = mdo
    vOp <- cgDecl' vType ident
    exprOp <- cgExpr expr
    store vOp 0 exprOp

cgDecl' :: Javalette.Abs.Type -> Ident -> CgMonad Operand
cgDecl' vType ident = mdo
    vOp <- alloca (encodeType vType) Nothing 1
    s <- get
    let newS = Map.insert ident vOp (Prelude.head s)
    put (newS: Prelude.tail s)
    return vOp

cgStm :: Stmt -> CgMonad ()
cgStm Empty = return ()
cgStm (BStmt (Block stms)) = mdo
    openBlock
    _ <- mapM cgStm stms
    closeBlock
cgStm (Decl vType decls) = mdo
    _ <- mapM (cgDecl vType) decls
    return ()
cgStm (Ass ident expr) = mdo
    vOp <- lookupVar ident
    exprOp <- cgExpr expr
    store vOp 0 exprOp
cgStm (Incr ident) = undefined
cgStm (Decr ident) = undefined
cgStm (Javalette.Abs.Ret expr) = mdo
    rOp <- cgExpr expr
    ret rOp
cgStm VRet = retVoid
cgStm (Cond expr stms) = mdo
    expOp <- cgExpr expr
    condBr expOp tBlock fBlock
    tBlock <- block `named` "true"
    cgStm stms
    br fBlock
    fBlock <- block `named` "false"
    return ()

cgStm (CondElse expr tStms fStms) = mdo
    expOp <- cgExpr expr
    condBr expOp tBlock fBlock
    tBlock <- block `named` "true"
    cgStm tStms
    br eBlock
    fBlock <- block `named` "false"
    cgStm fStms
    br eBlock
    eBlock <- block `named` "end" 
    return ()
cgStm (While expr stms) = undefined
cgStm (SExp expr) = mdo
    _ <- cgExpr expr
    return ()

cgExpr :: Expr -> CgMonad Operand
cgExpr (ETyped eType expr) = case expr of
    ETyped _ iexpr -> error "Malformed AST! Nested Etyped"
    EVar ident -> mdo 
        varPtr <- lookupVar ident
        load varPtr 0
    ELitInt i -> return $ ConstantOperand (C.Int 32 i)
    ELitDoub d -> return $ ConstantOperand (C.Float (F.Double d))
    ELitTrue -> return $ ConstantOperand (C.Int 1 1)
    ELitFalse -> return $ ConstantOperand (C.Int 1 0)
    EApp fIdent exprs -> mdo
        fOps <- mapM cgExpr exprs
        fPtr <- lookupFunction fIdent
        call fPtr (encodeFunOperands fOps)
    EString str -> mdo
        strptr <- globalStringPtr str (mkName str)
        return $ ConstantOperand strptr
    Neg sexpr -> mdo
        expOp <- cgExpr sexpr
        case eType of
          Int -> mul expOp (ConstantOperand (C.Int 32 (-1)))
          Doub -> fmul expOp (ConstantOperand (C.Float (F.Double (-1.0))))
          _ -> error "Malformed AST! Trying to negate non number"
    Not sexpr -> undefined
    EMul expr1 mulop expr2 -> mdo
        expOp1 <- cgExpr expr1
        expOp2 <- cgExpr expr2
        case eType of
            Doub -> case mulop of
              Times -> fmul expOp1 expOp2
              Div -> fdiv expOp1 expOp2
              Mod -> frem expOp1 expOp2
            _ -> case mulop of
              Times -> mul expOp1 expOp2
              Div -> sdiv expOp1 expOp2
              Mod -> srem expOp1 expOp2
    EAdd expr1 addop expr2 -> mdo
        expOp1 <- cgExpr expr1
        expOp2 <- cgExpr expr2
        case eType of
            Doub -> case addop of
              Plus -> fadd expOp1 expOp2
              Minus -> fsub expOp1 expOp2
            _ -> case addop of
              Plus -> add expOp1 expOp2
              Minus -> sub expOp1 expOp2
    ERel expr1 relop expr2 -> case eType of
    -- Doubles need a float comp instruction
      Doub -> mdo
        expOp1 <- cgExpr expr1
        expOp2 <- cgExpr expr2
        fcmp (encodeFRelOp relop) expOp1 expOp2
      _ -> mdo
        expOp1 <- cgExpr expr1
        expOp2 <- cgExpr expr2
        icmp (encodeIRelOp relop) expOp1 expOp2
    EAnd expr1 expr2 -> undefined
    EOr expr1 expr2 -> undefined
cgExpr (EString str) = mdo
    strptr <- globalStringPtr str (mkName str)
    return $ ConstantOperand strptr
cgExpr expr = error $ "Malformed AST! Expected eType, found " ++ show expr

encodeFRelOp :: RelOp -> FloatingPointPredicate
encodeFRelOp op = case op of
  LTH -> OLT
  LE -> OLE
  GTH -> OGT
  GE -> OGE
  EQU -> OEQ
  Javalette.Abs.NE -> ONE
encodeIRelOp :: RelOp -> IntegerPredicate
encodeIRelOp op = case op of
  LTH -> SLT
  LE -> SLE
  GTH -> SGT
  GE -> SGE
  EQU -> LLVM.AST.IntegerPredicate.EQ
  Javalette.Abs.NE -> LLVM.AST.IntegerPredicate.NE

encodeFunOperands :: [Operand] -> [(Operand, [ParameterAttribute])]
encodeFunOperands = map (\ o -> (o, []))

lookupFunction :: Ident -> CgMonad Operand
lookupFunction ident = mdo
    fsigs <- ask
    case Map.lookup ident fsigs of
      Nothing -> error $ "Malformed AST! Undefined JL function" ++ show ident
      Just op -> return op

lookupVar :: Ident -> CgMonad Operand
lookupVar ident = mdo
    s <- get
    return $ lookupVar' ident s

lookupVar' :: Ident -> [Map.Map Ident Operand] -> Operand
lookupVar' ident [] = error $ "Malformed AST! Undefined JL variable: " ++ show ident
lookupVar' ident (m:ms) = case Map.lookup ident m of
    Just o -> o
    Nothing -> lookupVar' ident ms

openBlock :: CgMonad ()
openBlock = mdo
    s <- get
    put (Map.empty : s)

closeBlock :: CgMonad ()
closeBlock = mdo
    s <- get
    put $ Prelude.tail s

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

