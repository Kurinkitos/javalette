module Main (main) where

import Lib
import System.IO

debug :: Bool
debug = False

main :: IO ()
main = do
  if debug then do
    handle <- openFile "/home/lilly/tda283/tester/testsuite/extensions/arrays1/array001.jl" ReadMode
    --handle <- openFile "small.jl" ReadMode
    program_src <- hGetContents handle
    compileProgram program_src 2
    hClose handle
  else do
    program_src <- getContents
    compileProgram program_src 0
