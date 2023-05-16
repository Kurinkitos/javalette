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

import Data.ByteString.Short as BSS
import Data.ByteString.Char8 as BSC hiding (tail, map)

import LLVM.AST hiding (function)
import LLVM.AST.AddrSpace

import LLVM.Pretty

import Data.Hashable

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
    callocPtr <- extern "calloc" [IntegerType 32, IntegerType 32] (PointerType (IntegerType 8) (AddrSpace 0))
    return
        [ (Ident "printInt", printIntPtr)
        , (Ident "printDouble", printDoublePtr)
        , (Ident "printString", printStringPtr)
        , (Ident "readInt", readIntPtr)
        , (Ident "readDouble", readDoublePtr)
        , (Ident "calloc", callocPtr)
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
            isTerminated <- hasTerminator
            if isTerminated then
                return ()
            else mdo
                unreachable



argToIdent :: Arg -> Ident
argToIdent (Argument _ ident) = ident

cgFnBody :: [Stmt] -> [Arg] -> [Operand] -> CgMonad ()
cgFnBody stms idents oprs = mdo
    _entry <- block
    pushArguments $ Prelude.zip idents oprs
    _ <- mapM cgStm stms
    return ()

pushArguments :: [(Arg, Operand)] -> CgMonad ()
pushArguments arg = mdo
    ops <- mapM pushArgument arg
    put [Map.fromList (Prelude.zip idents ops)]
    where
        idents = map (argToIdent . fst) arg
-- Allocates a new variable and copies the argument to it. This is needed to allow overwriting function arguments
pushArgument :: (Arg, Operand) -> CgMonad Operand
pushArgument (Argument aType _ident, op)= mdo
    aOp <- alloca (encodeType aType) Nothing 1
    store aOp 0 op
    return aOp



cgDecl :: Javalette.Abs.Type -> Item -> CgMonad ()
cgDecl vType (NoInitVar ident) = mdo
    vOp <- cgDecl' vType ident
    -- Default values for variables
    case vType of
      Int -> store vOp 0 (ConstantOperand (C.Int 32 0))
      Doub -> store vOp 0 (ConstantOperand (C.Float (F.Double 0.0)))
      Bool -> store vOp 0 (ConstantOperand (C.Int 1 0))
      Array _ -> mdo
        -- Similar logic as in new, but with an array size of zero
        let intSize = C.sizeof (encodeType Int)
        callocPtr <- lookupFunction (Ident "calloc")
        arrayMemPtr <- call callocPtr [(ConstantOperand intSize, []), (ConstantOperand (C.Int 32 1), [])]
        --  Get a pointer of the right type
        arrayPtr <- bitcast arrayMemPtr (encodeType vType)
        lengthAddr <- gep arrayPtr [ConstantOperand (C.Int 32 0)]
        -- This is not nessesary in LLVM, but llvm-hs-pure emits the wrong types from gep so we need to cast
        lengthPtr <- bitcast lengthAddr (PointerType (encodeType Int) (AddrSpace 0))
        store lengthPtr 0 (ConstantOperand (C.Int 32 0))
        store vOp 0 arrayPtr
      _ -> error "Malformed AST! Variable of dissalowed type"
cgDecl vType (Init ident expr) = mdo
    exprOp <- cgRValue expr
    vOp <- cgDecl' vType ident
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
cgStm (Ass lExpr rExpr) = mdo
    lOp <- cgLValue lExpr
    rOp <- cgRValue rExpr
    store lOp 0 rOp

cgStm (Incr ident) = mdo
    vOp <- lookupVar ident
    vVal <- load vOp 0
    vInc <- add vVal (ConstantOperand (C.Int 32 1))
    store vOp 0 vInc
cgStm (Decr ident) = mdo
    vOp <- lookupVar ident
    vVal <- load vOp 0
    vInc <- add vVal (ConstantOperand (C.Int 32 (-1)))
    store vOp 0 vInc
cgStm (Javalette.Abs.Ret expr) = mdo
    rOp <- cgRValue expr
    ret rOp
cgStm VRet = retVoid
cgStm (Cond expr stms) = mdo
    expOp <- cgRValue expr
    condBr expOp tBlock fBlock
    tBlock <- block `named` "true"
    cgStm stms
    -- To handle a bug in IRBuilder we need to handle the case where the block from stms emited a terminator like ret
    isTerminated <- hasTerminator
    if isTerminated then mdo
        _unreachBlock <- block `named` "unreachable"
        unreachable
    else mdo
        br fBlock
    fBlock <- block `named` "false"
    return ()

cgStm (CondElse expr tStms fStms) = mdo
    expOp <- cgRValue expr
    condBr expOp tBlock fBlock
    tBlock <- block `named` "true"
    cgStm tStms
    -- To handle a bug in IRBuilder we need to handle the case where the block from stms emited a terminator like ret
    isTerminated <- hasTerminator
    if isTerminated then mdo
        _unreachBlock <- block `named` "unreachable"
        unreachable
    else mdo
        br eBlock
    fBlock <- block `named` "false"
    cgStm fStms
    -- To handle a bug in IRBuilder we need to handle the case where the block from stms emited a terminator like ret
    isTerminated2 <- hasTerminator
    if isTerminated2 then mdo
        _unreachBlock <- block `named` "unreachable"
        unreachable
    else mdo
        br eBlock
    eBlock <- block `named` "end"
    return ()
cgStm (While expr stms) = mdo
    br condL
    condL <- block `named` "condition"
    condOp <- cgRValue expr
    condBr condOp loopBody endL
    loopBody <- block `named` "loopBody"
    cgStm stms
    isTerminated <- hasTerminator
    if isTerminated then mdo
        _unreachBlock <- block `named` "unreachable"
        unreachable
    else mdo
        br condL
    endL <- block `named` "endL"
    return ()
cgStm (For elemType itVarIdent arrExpr stms) = mdo
    br start
    start <- block `named` "start"
    -- Allocate the variable to hold the elements
    cgDecl elemType (NoInitVar itVarIdent)
    itElemVar <- lookupVar itVarIdent
    -- A variable to keep what element we are on
    itCount <- alloca (encodeType Int) Nothing 0
    store itCount 0 (ConstantOperand (C.Int 32 0))
    -- Get array length
    arrOp <- cgRValue arrExpr 
    --arrOp <- load arrPtr 0
    lengthAddr <- gep arrOp [ConstantOperand (C.Int 32 0), ConstantOperand (C.Int 32 0)]
    arrayLength <- load lengthAddr 0
    -- Start of loop
    br loopL
    loopL <- block `named` "loopL"
    -- Load current element
    offset <- load itCount 0
    elementAddr <- gep arrOp [ConstantOperand (C.Int 32 0), ConstantOperand (C.Int 32 1), offset]
    elementOp <- load elementAddr 0
    store itElemVar 0 elementOp
    cgStm stms
    -- Increment counter
    itVal <- load itCount 0
    newVal <- add itVal (ConstantOperand (C.Int 32 1))
    store itCount 0 newVal
    endOfList <- icmp (encodeIRelOp GE) newVal arrayLength
    condBr endOfList end loopL
    end <- block `named` "endL"
    return ()


cgStm (SExp expr) = mdo
    _ <- cgRValue expr
    return ()

-- If the expression if a LValue or RValue, 
-- used to determine if the adress or value should be in the returned operand
data ValueKind = LValue | RValue
    deriving (Show, Eq, Enum)
cgLValue :: Expr -> CgMonad Operand
cgLValue = cgExpr LValue
cgRValue :: Expr -> CgMonad Operand
cgRValue = cgExpr RValue

cgExpr :: ValueKind -> Expr -> CgMonad Operand
cgExpr valueKind (ETyped eType expr) = case expr of
    ETyped _ _iexpr -> error "Malformed AST! Nested Etyped"
    EVar ident -> mdo
        varPtr <- lookupVar ident
        case valueKind of
          LValue -> return varPtr
          RValue -> load varPtr 0
    ELitInt i -> return $ ConstantOperand (C.Int 32 i)
    ELitDoub d -> return $ ConstantOperand (C.Float (F.Double d))
    ELitTrue -> return $ ConstantOperand (C.Int 1 1)
    ELitFalse -> return $ ConstantOperand (C.Int 1 0)
    EApp fIdent exprs -> mdo
        fOps <- mapM (cgExpr RValue) exprs
        fPtr <- lookupFunction fIdent
        call fPtr (encodeFunOperands fOps)
    EString _str -> mdo -- String literals is handled in a special case since it is not a type
        error "Unreachable!"
    Neg sexpr -> mdo
        expOp <- cgExpr RValue sexpr
        case eType of
          Int -> mul expOp (ConstantOperand (C.Int 32 (-1)))
          Doub -> fmul expOp (ConstantOperand (C.Float (F.Double (-1.0))))
          _ -> error "Malformed AST! Trying to negate non number"
    Not sexpr -> mdo
        sexpOp <- cgExpr RValue sexpr
        select sexpOp (ConstantOperand (C.Int 1 0)) (ConstantOperand (C.Int 1 1))
    EMul expr1 mulop expr2 -> mdo
        expOp1 <- cgExpr RValue expr1
        expOp2 <- cgExpr RValue expr2
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
        expOp1 <- cgExpr RValue expr1
        expOp2 <- cgExpr RValue expr2
        case eType of
            Doub -> case addop of
              Plus -> fadd expOp1 expOp2
              Minus -> fsub expOp1 expOp2
            _ -> case addop of
              Plus -> add expOp1 expOp2
              Minus -> sub expOp1 expOp2
    ERel expr1 relop expr2 -> case expr1 of
    -- Doubles need a float comp instruction
      ETyped Doub _sExp1 -> mdo
        expOp1 <- cgExpr RValue expr1
        expOp2 <- cgExpr RValue expr2
        fcmp (encodeFRelOp relop) expOp1 expOp2
      _ -> mdo
        expOp1 <- cgExpr RValue expr1
        expOp2 <- cgExpr RValue expr2
        icmp (encodeIRelOp relop) expOp1 expOp2
    EAnd expr1 expr2 -> mdo
        -- To make shortcutting work properly, and to describe it using the irbuilder there is gonna be some ugly stack storage here
        -- llvm-opt does remove all of it so it is not really a problem
        res_ptr <- alloca (encodeType Bool) Nothing 0
        expr1Op <- cgExpr RValue expr1
        condBr expr1Op e1True falseL
        e1True <- block `named` "e1True"
        expr2Op <- cgExpr RValue expr2
        condBr expr2Op trueL falseL
        trueL <- block `named` "trueL"
        store res_ptr 0 (ConstantOperand (C.Int 1 1))
        br endL
        falseL <- block `named` "falseL"
        store res_ptr 0 (ConstantOperand (C.Int 1 0))
        br endL
        endL <- block `named` "end"
        load res_ptr 0
    EOr expr1 expr2 -> mdo
        -- Same deal here as with and, but with reversed logic
        res_ptr <- alloca (encodeType Bool) Nothing 0
        expr1Op <- cgExpr RValue expr1
        condBr expr1Op trueL e1False
        e1False <- block `named` "e1False"
        expr2Op <- cgExpr RValue expr2
        condBr expr2Op trueL falseL
        trueL <- block `named` "trueL"
        store res_ptr 0 (ConstantOperand (C.Int 1 1))
        br endL
        falseL <- block `named` "falseL"
        store res_ptr 0 (ConstantOperand (C.Int 1 0))
        br endL
        endL <- block `named` "end"
        load res_ptr 0
    ENew t sExpr -> mdo
        nElements <- cgExpr RValue sExpr
        let elemSize = C.sizeof (encodeType t)
        arraySize <- mul nElements (ConstantOperand elemSize)
        let intSize = C.sizeof (encodeType Int)
        -- total memory to allocate, adding a int to keep the size of the array
        memAmount <- add arraySize (ConstantOperand intSize)
        callocPtr <- lookupFunction (Ident "calloc")
        arrayMemPtr <- call callocPtr [(memAmount, []), (ConstantOperand (C.Int 32 1), [])]
        --  Get a pointer of the right type
        arrayPtr <- bitcast arrayMemPtr (encodeType eType)
        lengthAddr <- gep arrayPtr [ConstantOperand (C.Int 32 0)]
        -- This is not nessesary in LLVM, but llvm-hs-pure emits the wrong types from gep so we need to cast
        lengthPtr <- bitcast lengthAddr (PointerType (encodeType Int) (AddrSpace 0))
        store lengthPtr 0 nElements
        return arrayPtr
    EIndex aExpr iExpr -> mdo
        arrPtr <- cgExpr RValue aExpr
        indexOp <- cgExpr RValue iExpr
        indexAddr <- gep arrPtr
            [ConstantOperand (C.Int 32 0) -- Get the structure pointer
            , ConstantOperand (C.Int 32 1) -- Get the array from the structure
            , indexOp -- Finally index the array
            ]
        case valueKind of
          RValue -> load indexAddr 0
          LValue -> return indexAddr

    ESelect aExpr (Ident "length") -> mdo
        arrPtr <- cgExpr RValue aExpr
        lengthAddr <- gep arrPtr [ConstantOperand (C.Int 32 0), ConstantOperand (C.Int 32 0)]
        load lengthAddr 0
    ESelect _sExpr _ident -> error "Only supports .length for now"

cgExpr _ (EString str) = mdo
    let str_hash = BSS.toShort $ BSC.pack $ show $ hash str
    strName <- freshName str_hash
    strptr <- globalStringPtr str strName
    return $ ConstantOperand strptr
cgExpr _ expr = error $ "Malformed AST! Expected eType, found " ++ show expr

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
encodeType (Array elemType) = PointerType (StructureType False [IntegerType 32, ArrayType 0 (encodeType elemType)]) (AddrSpace 0)
encodeType (Fun _retType _args) = error "No function types allowed!" --Should not happen, since we don't have function pointers

encodeArgs :: [Arg] -> [(LLVM.AST.Type, ParameterName)]
encodeArgs = map encodeArg

encodeArg :: Arg -> (LLVM.AST.Type, ParameterName)
encodeArg (Argument aType ident) = (encodeType aType, identToParName ident)

