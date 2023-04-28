-- File generated by the BNF Converter (bnfc 2.9.4.1).

{-# LANGUAGE CPP #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase #-}
#if __GLASGOW_HASKELL__ <= 708
{-# LANGUAGE OverlappingInstances #-}
#endif

-- | Pretty-printer for Javalette.

module Javalette.Print where

import Prelude
  ( ($), (.)
  , Bool(..), (==), (<)
  , Int, Integer, Double, (+), (-), (*)
  , String, (++)
  , ShowS, showChar, showString
  , all, elem, foldr, id, map, null, replicate, shows, span
  )
import Data.Char ( Char, isSpace )
import qualified Javalette.Abs

-- | The top-level printing method.

printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 False (map ($ "") $ d []) ""
  where
  rend
    :: Int        -- ^ Indentation level.
    -> Bool       -- ^ Pending indentation to be output before next character?
    -> [String]
    -> ShowS
  rend i p = \case
      "["      :ts -> char '[' . rend i False ts
      "("      :ts -> char '(' . rend i False ts
      "{"      :ts -> onNewLine i     p . showChar   '{'  . new (i+1) ts
      "}" : ";":ts -> onNewLine (i-1) p . showString "};" . new (i-1) ts
      "}"      :ts -> onNewLine (i-1) p . showChar   '}'  . new (i-1) ts
      [";"]        -> char ';'
      ";"      :ts -> char ';' . new i ts
      t  : ts@(s:_) | closingOrPunctuation s
                   -> pending . showString t . rend i False ts
      t        :ts -> pending . space t      . rend i False ts
      []           -> id
    where
    -- Output character after pending indentation.
    char :: Char -> ShowS
    char c = pending . showChar c

    -- Output pending indentation.
    pending :: ShowS
    pending = if p then indent i else id

  -- Indentation (spaces) for given indentation level.
  indent :: Int -> ShowS
  indent i = replicateS (2*i) (showChar ' ')

  -- Continue rendering in new line with new indentation.
  new :: Int -> [String] -> ShowS
  new j ts = showChar '\n' . rend j True ts

  -- Make sure we are on a fresh line.
  onNewLine :: Int -> Bool -> ShowS
  onNewLine i p = (if p then id else showChar '\n') . indent i

  -- Separate given string from following text by a space (if needed).
  space :: String -> ShowS
  space t s =
    case (all isSpace t', null spc, null rest) of
      (True , _   , True ) -> []              -- remove trailing space
      (False, _   , True ) -> t'              -- remove trailing space
      (False, True, False) -> t' ++ ' ' : s   -- add space if none
      _                    -> t' ++ s
    where
      t'          = showString t []
      (spc, rest) = span isSpace s

  closingOrPunctuation :: String -> Bool
  closingOrPunctuation [c] = c `elem` closerOrPunct
  closingOrPunctuation _   = False

  closerOrPunct :: String
  closerOrPunct = ")],;"

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- | The printer class does the job.

class Print a where
  prt :: Int -> a -> Doc

instance {-# OVERLAPPABLE #-} Print a => Print [a] where
  prt i = concatD . map (prt i)

instance Print Char where
  prt _ c = doc (showChar '\'' . mkEsc '\'' c . showChar '\'')

instance Print String where
  prt _ = printString

printString :: String -> Doc
printString s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q = \case
  s | s == q -> showChar '\\' . showChar s
  '\\' -> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  s -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j < i then parenth else id

instance Print Integer where
  prt _ x = doc (shows x)

instance Print Double where
  prt _ x = doc (shows x)

instance Print Javalette.Abs.Ident where
  prt _ (Javalette.Abs.Ident i) = doc $ showString i
instance Print Javalette.Abs.Prog where
  prt i = \case
    Javalette.Abs.Program topdefs -> prPrec i 0 (concatD [prt 0 topdefs])

instance Print Javalette.Abs.TopDef where
  prt i = \case
    Javalette.Abs.FnDef type_ id_ args blk -> prPrec i 0 (concatD [prt 0 type_, prt 0 id_, doc (showString "("), prt 0 args, doc (showString ")"), prt 0 blk])

instance Print [Javalette.Abs.TopDef] where
  prt _ [] = concatD []
  prt _ [x] = concatD [prt 0 x]
  prt _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print Javalette.Abs.Arg where
  prt i = \case
    Javalette.Abs.Argument type_ id_ -> prPrec i 0 (concatD [prt 0 type_, prt 0 id_])

instance Print [Javalette.Abs.Arg] where
  prt _ [] = concatD []
  prt _ [x] = concatD [prt 0 x]
  prt _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print Javalette.Abs.Blk where
  prt i = \case
    Javalette.Abs.Block stmts -> prPrec i 0 (concatD [doc (showString "{"), prt 0 stmts, doc (showString "}")])

instance Print [Javalette.Abs.Stmt] where
  prt _ [] = concatD []
  prt _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print Javalette.Abs.Stmt where
  prt i = \case
    Javalette.Abs.Empty -> prPrec i 0 (concatD [doc (showString ";")])
    Javalette.Abs.BStmt blk -> prPrec i 0 (concatD [prt 0 blk])
    Javalette.Abs.Decl type_ items -> prPrec i 0 (concatD [prt 0 type_, prt 0 items, doc (showString ";")])
    Javalette.Abs.Ass lval expr -> prPrec i 0 (concatD [prt 0 lval, doc (showString "="), prt 0 expr, doc (showString ";")])
    Javalette.Abs.Incr id_ -> prPrec i 0 (concatD [prt 0 id_, doc (showString "++"), doc (showString ";")])
    Javalette.Abs.Decr id_ -> prPrec i 0 (concatD [prt 0 id_, doc (showString "--"), doc (showString ";")])
    Javalette.Abs.Ret expr -> prPrec i 0 (concatD [doc (showString "return"), prt 0 expr, doc (showString ";")])
    Javalette.Abs.VRet -> prPrec i 0 (concatD [doc (showString "return"), doc (showString ";")])
    Javalette.Abs.Cond expr stmt -> prPrec i 0 (concatD [doc (showString "if"), doc (showString "("), prt 0 expr, doc (showString ")"), prt 0 stmt])
    Javalette.Abs.CondElse expr stmt1 stmt2 -> prPrec i 0 (concatD [doc (showString "if"), doc (showString "("), prt 0 expr, doc (showString ")"), prt 0 stmt1, doc (showString "else"), prt 0 stmt2])
    Javalette.Abs.While expr stmt -> prPrec i 0 (concatD [doc (showString "while"), doc (showString "("), prt 0 expr, doc (showString ")"), prt 0 stmt])
    Javalette.Abs.For type_ id_ expr stmt -> prPrec i 0 (concatD [doc (showString "for"), doc (showString "("), prt 0 type_, prt 0 id_, doc (showString ":"), prt 0 expr, doc (showString ")"), prt 0 stmt])
    Javalette.Abs.SExp expr -> prPrec i 0 (concatD [prt 0 expr, doc (showString ";")])

instance Print Javalette.Abs.Item where
  prt i = \case
    Javalette.Abs.NoInitVar id_ -> prPrec i 0 (concatD [prt 0 id_])
    Javalette.Abs.NoInitArr id_ -> prPrec i 0 (concatD [prt 0 id_, doc (showString "["), doc (showString "]")])
    Javalette.Abs.Init id_ expr -> prPrec i 0 (concatD [prt 0 id_, doc (showString "="), prt 0 expr])

instance Print [Javalette.Abs.Item] where
  prt _ [] = concatD []
  prt _ [x] = concatD [prt 0 x]
  prt _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print Javalette.Abs.LVal where
  prt i = \case
    Javalette.Abs.LIdent id_ -> prPrec i 0 (concatD [prt 0 id_])
    Javalette.Abs.LIndex id_ expr -> prPrec i 0 (concatD [prt 0 id_, doc (showString "["), prt 6 expr, doc (showString "]")])

instance Print Javalette.Abs.Type where
  prt i = \case
    Javalette.Abs.Array type_ -> prPrec i 0 (concatD [prt 0 type_, doc (showString "["), doc (showString "]")])
    Javalette.Abs.Int -> prPrec i 0 (concatD [doc (showString "int")])
    Javalette.Abs.Doub -> prPrec i 0 (concatD [doc (showString "double")])
    Javalette.Abs.Bool -> prPrec i 0 (concatD [doc (showString "boolean")])
    Javalette.Abs.Void -> prPrec i 0 (concatD [doc (showString "void")])
    Javalette.Abs.Fun type_ types -> prPrec i 0 (concatD [prt 0 type_, doc (showString "("), prt 0 types, doc (showString ")")])

instance Print [Javalette.Abs.Type] where
  prt _ [] = concatD []
  prt _ [x] = concatD [prt 0 x]
  prt _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print Javalette.Abs.Expr where
  prt i = \case
    Javalette.Abs.ETyped type_ expr -> prPrec i 8 (concatD [prt 0 type_, doc (showString "::"), prt 7 expr])
    Javalette.Abs.ENew type_ expr -> prPrec i 7 (concatD [doc (showString "new"), prt 0 type_, doc (showString "["), prt 6 expr, doc (showString "]")])
    Javalette.Abs.EIndex id_ expr -> prPrec i 7 (concatD [prt 0 id_, doc (showString "["), prt 6 expr, doc (showString "]")])
    Javalette.Abs.ELength id_ -> prPrec i 6 (concatD [prt 0 id_, doc (showString "."), doc (showString "length")])
    Javalette.Abs.EVar id_ -> prPrec i 6 (concatD [prt 0 id_])
    Javalette.Abs.ELitInt n -> prPrec i 6 (concatD [prt 0 n])
    Javalette.Abs.ELitDoub d -> prPrec i 6 (concatD [prt 0 d])
    Javalette.Abs.ELitTrue -> prPrec i 6 (concatD [doc (showString "true")])
    Javalette.Abs.ELitFalse -> prPrec i 6 (concatD [doc (showString "false")])
    Javalette.Abs.EApp id_ exprs -> prPrec i 6 (concatD [prt 0 id_, doc (showString "("), prt 0 exprs, doc (showString ")")])
    Javalette.Abs.EString str -> prPrec i 6 (concatD [printString str])
    Javalette.Abs.Neg expr -> prPrec i 5 (concatD [doc (showString "-"), prt 7 expr])
    Javalette.Abs.Not expr -> prPrec i 5 (concatD [doc (showString "!"), prt 7 expr])
    Javalette.Abs.EMul expr1 mulop expr2 -> prPrec i 4 (concatD [prt 4 expr1, prt 0 mulop, prt 5 expr2])
    Javalette.Abs.EAdd expr1 addop expr2 -> prPrec i 3 (concatD [prt 3 expr1, prt 0 addop, prt 4 expr2])
    Javalette.Abs.ERel expr1 relop expr2 -> prPrec i 2 (concatD [prt 2 expr1, prt 0 relop, prt 3 expr2])
    Javalette.Abs.EAnd expr1 expr2 -> prPrec i 1 (concatD [prt 2 expr1, doc (showString "&&"), prt 1 expr2])
    Javalette.Abs.EOr expr1 expr2 -> prPrec i 0 (concatD [prt 1 expr1, doc (showString "||"), prt 0 expr2])

instance Print [Javalette.Abs.Expr] where
  prt _ [] = concatD []
  prt _ [x] = concatD [prt 0 x]
  prt _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print Javalette.Abs.AddOp where
  prt i = \case
    Javalette.Abs.Plus -> prPrec i 0 (concatD [doc (showString "+")])
    Javalette.Abs.Minus -> prPrec i 0 (concatD [doc (showString "-")])

instance Print Javalette.Abs.MulOp where
  prt i = \case
    Javalette.Abs.Times -> prPrec i 0 (concatD [doc (showString "*")])
    Javalette.Abs.Div -> prPrec i 0 (concatD [doc (showString "/")])
    Javalette.Abs.Mod -> prPrec i 0 (concatD [doc (showString "%")])

instance Print Javalette.Abs.RelOp where
  prt i = \case
    Javalette.Abs.LTH -> prPrec i 0 (concatD [doc (showString "<")])
    Javalette.Abs.LE -> prPrec i 0 (concatD [doc (showString "<=")])
    Javalette.Abs.GTH -> prPrec i 0 (concatD [doc (showString ">")])
    Javalette.Abs.GE -> prPrec i 0 (concatD [doc (showString ">=")])
    Javalette.Abs.EQU -> prPrec i 0 (concatD [doc (showString "==")])
    Javalette.Abs.NE -> prPrec i 0 (concatD [doc (showString "!=")])
