module Main (main) where

import Lib
import System.IO

main :: IO ()
main = do
  --program_src <- getContents
  handle <- openFile "/home/lilly/tda283/tester/testsuite/good/core004.jl" ReadMode
  program_src <- hGetContents handle
  compileProgram program_src 2
  hClose handle
  --compileProgram program_src 2
