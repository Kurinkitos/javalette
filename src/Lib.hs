module Lib
    ( compileProgram
    ) where

import Javalette.Par ( myLexer, pProg, pProg, myLexer )
import System.Exit        ( exitFailure )
import Control.Monad      ( when)
import System.IO (hPutStrLn, stderr)

import Javalette.Print ( Print, printTree )
import Javalette.Skel  ()

import Typecheck ( typecheck, Symbols)
import Javalette.Abs (Prog)
import LLVMBackend (compile)



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
          showTree v ast
          hPutStrLn stderr "TYPE ERROR"
          hPutStrLn stderr err
          exitFailure
        Right (prog, symbols) -> do
          hPutStrLn stderr "OK"
          showTree v prog
          compileProgram' prog symbols

compileProgram' :: Prog -> Symbols -> IO ()
compileProgram' program symbols = do
  let llvm_ir = compile program symbols
  putStr llvm_ir

-- Debug functions
type Verbosity  = Int

putStrV :: Verbosity -> String -> IO ()
putStrV v s = when (v > 1) $ hPutStrLn stderr s

showTree :: (Show a, Print a) => Int -> a -> IO ()
showTree v tree = do
  putStrV v $ "\n[Abstract Syntax]\n\n" ++ show tree
  putStrV v $ "\n[Linearized tree]\n\n" ++ printTree tree
