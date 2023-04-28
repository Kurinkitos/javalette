-- File generated by the BNF Converter (bnfc 2.9.4.1).

{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- | The abstract syntax of language Javalette.

module Javalette.Abs where

import Prelude (Double, Integer, String)
import qualified Prelude as C (Eq, Ord, Show, Read)
import qualified Data.String

data Prog = Program [TopDef]
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data TopDef = FnDef Type Ident [Arg] Blk
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Arg = Argument Type Ident
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Blk = Block [Stmt]
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Stmt
    = Empty
    | BStmt Blk
    | Decl Type [Item]
    | Ass LVal Expr
    | Incr Ident
    | Decr Ident
    | Ret Expr
    | VRet
    | Cond Expr Stmt
    | CondElse Expr Stmt Stmt
    | While Expr Stmt
    | For Type Ident Expr Stmt
    | SExp Expr
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Item = NoInitVar Ident | NoInitArr Ident | Init Ident Expr
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data LVal = LIdent Ident | LIndex Ident Expr
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Type = Array Type | Int | Doub | Bool | Void | Fun Type [Type]
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Expr
    = ETyped Type Expr
    | ENew Type Expr
    | EIndex Ident Expr
    | ELength Ident
    | EVar Ident
    | ELitInt Integer
    | ELitDoub Double
    | ELitTrue
    | ELitFalse
    | EApp Ident [Expr]
    | EString String
    | Neg Expr
    | Not Expr
    | EMul Expr MulOp Expr
    | EAdd Expr AddOp Expr
    | ERel Expr RelOp Expr
    | EAnd Expr Expr
    | EOr Expr Expr
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data AddOp = Plus | Minus
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data MulOp = Times | Div | Mod
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data RelOp = LTH | LE | GTH | GE | EQU | NE
  deriving (C.Eq, C.Ord, C.Show, C.Read)

newtype Ident = Ident String
  deriving (C.Eq, C.Ord, C.Show, C.Read, Data.String.IsString)

