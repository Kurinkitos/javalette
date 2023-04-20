module Main (main) where

import Lib
import System.IO

debug :: Bool
debug = True

main :: IO ()
main = do
  if debug then do
    handle <- openFile "/home/lilly/tda283/tester/testsuite/good/core032.jl" ReadMode
    program_src <- hGetContents handle
    compileProgram program_src 2
    hClose handle
  else do
    program_src <- getContents
    compileProgram program_src 0
