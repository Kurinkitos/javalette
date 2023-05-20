module Main (main) where

import Lib ( compileProgram )
main :: IO ()
main = do
  program_src <- getContents
  compileProgram program_src 0
