-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module Javalette.Skel where

import Prelude (($), Either(..), String, (++), Show, show)
import qualified Javalette.Abs

type Err = Either String
type Result = Err String

failure :: Show a => a -> Result
failure x = Left $ "Undefined case: " ++ show x

transIdent :: Javalette.Abs.Ident -> Result
transIdent x = case x of
  Javalette.Abs.Ident string -> failure x

transProg :: Javalette.Abs.Prog -> Result
transProg x = case x of
  Javalette.Abs.Program topdefs -> failure x

transTopDef :: Javalette.Abs.TopDef -> Result
transTopDef x = case x of
  Javalette.Abs.FnDef type_ ident args blk -> failure x

transArg :: Javalette.Abs.Arg -> Result
transArg x = case x of
  Javalette.Abs.Argument type_ ident -> failure x

transBlk :: Javalette.Abs.Blk -> Result
transBlk x = case x of
  Javalette.Abs.Block stmts -> failure x

transStmt :: Javalette.Abs.Stmt -> Result
transStmt x = case x of
  Javalette.Abs.Empty -> failure x
  Javalette.Abs.BStmt blk -> failure x
  Javalette.Abs.Decl type_ items -> failure x
  Javalette.Abs.Ass expr1 expr2 -> failure x
  Javalette.Abs.Incr ident -> failure x
  Javalette.Abs.Decr ident -> failure x
  Javalette.Abs.Ret expr -> failure x
  Javalette.Abs.VRet -> failure x
  Javalette.Abs.Cond expr stmt -> failure x
  Javalette.Abs.CondElse expr stmt1 stmt2 -> failure x
  Javalette.Abs.While expr stmt -> failure x
  Javalette.Abs.For type_ ident expr stmt -> failure x
  Javalette.Abs.SExp expr -> failure x

transItem :: Javalette.Abs.Item -> Result
transItem x = case x of
  Javalette.Abs.NoInitVar ident -> failure x
  Javalette.Abs.Init ident expr -> failure x

transType :: Javalette.Abs.Type -> Result
transType x = case x of
  Javalette.Abs.Array type_ -> failure x
  Javalette.Abs.Int -> failure x
  Javalette.Abs.Doub -> failure x
  Javalette.Abs.Bool -> failure x
  Javalette.Abs.Void -> failure x
  Javalette.Abs.Fun type_ types -> failure x

transExpr :: Javalette.Abs.Expr -> Result
transExpr x = case x of
  Javalette.Abs.ETyped type_ expr -> failure x
  Javalette.Abs.ENew type_ expr -> failure x
  Javalette.Abs.EIndex expr1 expr2 -> failure x
  Javalette.Abs.ESelect expr ident -> failure x
  Javalette.Abs.EVar ident -> failure x
  Javalette.Abs.ELitInt integer -> failure x
  Javalette.Abs.ELitDoub double -> failure x
  Javalette.Abs.ELitTrue -> failure x
  Javalette.Abs.ELitFalse -> failure x
  Javalette.Abs.EApp ident exprs -> failure x
  Javalette.Abs.EString string -> failure x
  Javalette.Abs.Neg expr -> failure x
  Javalette.Abs.Not expr -> failure x
  Javalette.Abs.EMul expr1 mulop expr2 -> failure x
  Javalette.Abs.EAdd expr1 addop expr2 -> failure x
  Javalette.Abs.ERel expr1 relop expr2 -> failure x
  Javalette.Abs.EAnd expr1 expr2 -> failure x
  Javalette.Abs.EOr expr1 expr2 -> failure x

transAddOp :: Javalette.Abs.AddOp -> Result
transAddOp x = case x of
  Javalette.Abs.Plus -> failure x
  Javalette.Abs.Minus -> failure x

transMulOp :: Javalette.Abs.MulOp -> Result
transMulOp x = case x of
  Javalette.Abs.Times -> failure x
  Javalette.Abs.Div -> failure x
  Javalette.Abs.Mod -> failure x

transRelOp :: Javalette.Abs.RelOp -> Result
transRelOp x = case x of
  Javalette.Abs.LTH -> failure x
  Javalette.Abs.LE -> failure x
  Javalette.Abs.GTH -> failure x
  Javalette.Abs.GE -> failure x
  Javalette.Abs.EQU -> failure x
  Javalette.Abs.NE -> failure x
