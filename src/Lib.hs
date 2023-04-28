module Lib
    ( compileProgram
    ) where

import Javalette.Par ( myLexer, pProg, pProg, myLexer )
import System.Exit        ( exitFailure )
import Control.Monad      ( when)
import System.IO (hPutStrLn, stderr)

import Javalette.Lex   ( Token, mkPosToken )
import Javalette.Print ( Print, printTree )
import Javalette.Skel  ()

import Typecheck ( typecheck, FunctionSig)
import Javalette.Abs (Prog, Ident)
import LLVMBackend (compile)
import qualified Data.Map as Map



compileProgram :: String -> Int -> IO ()
compileProgram program v =
  case pProg (myLexer program) of
    Left err -> do
      hPutStrLn stderr "PARSE ERROR"
      hPutStrLn stderr err
      exitFailure
    Right ast ->
      case typecheck ast of
        Left err -> do
          hPutStrLn stderr "TYPE ERROR"
          hPutStrLn stderr err
          exitFailure
        Right (prog, fsigs) -> do
          hPutStrLn stderr "OK"
          showTree v prog
          compileProgram' prog fsigs

compileProgram' :: Prog -> Map.Map Ident FunctionSig -> IO ()
compileProgram' program fsigs = do
  let llvm_ir = compile program fsigs
  putStr llvm_ir

-- Debug functions
type Err        = Either String
type ParseFun a = [Token] -> Err a
type Verbosity  = Int

putStrV :: Verbosity -> String -> IO ()
putStrV v s = when (v > 1) $ hPutStrLn stderr s

run :: (Print a, Show a) => Verbosity -> ParseFun a -> String -> IO ()
run v p s =
  case p ts of
    Left err -> do
      putStrLn "\nParse              Failed...\n"
      putStrV v "Tokens:"
      hPutStrLn stderr "ERROR"
      mapM_ (putStrV v . showPosToken . mkPosToken) ts
      putStrLn err
      exitFailure
    Right tree -> do
      hPutStrLn stderr "OK"
      putStrLn "\nParse Successful!"
      showTree v tree
  where
  ts = myLexer s
  showPosToken ((l,c),t) = concat [ show l, ":", show c, "\t", show t ]

showTree :: (Show a, Print a) => Int -> a -> IO ()
showTree v tree = do
  putStrV v $ "\n[Abstract Syntax]\n\n" ++ show tree
  putStrV v $ "\n[Linearized tree]\n\n" ++ printTree tree
