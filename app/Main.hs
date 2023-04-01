module Main (main) where

import Lib

main :: IO ()
main = do
  program_src <- getContents
  compileProgram program_src 2
