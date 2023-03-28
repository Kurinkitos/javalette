module Lib
    ( compileProgram
    ) where

import Javalette.Par ( myLexer, pProg )
import System.Exit        ( exitFailure )
import Control.Monad      ( when, foldM )
import System.IO (hPutStrLn, stderr)

import Javalette.Abs   ( Prog )
import Javalette.Lex   ( Token, mkPosToken )
import Javalette.Par   ( pProg, myLexer )
import Javalette.Print ( Print, printTree )
import Javalette.Skel  ()

import Typecheck ( typecheck)



compileProgram :: String -> Int -> IO ()
compileProgram program v = 
  case pProg (myLexer program) of
    Left err -> do
      hPutStrLn stderr "ERROR"
      putStrLn err
    Right ast -> 
      case typecheck ast of
        Left err -> do
          hPutStrLn stderr "ERROR"
          putStrLn err
        Right prog -> do
          hPutStrLn stderr "OK"
          putStrLn "\nParse Successful!"



type Err        = Either String
type ParseFun a = [Token] -> Err a
type Verbosity  = Int

putStrV :: Verbosity -> String -> IO ()
putStrV v s = when (v > 1) $ putStrLn s

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
