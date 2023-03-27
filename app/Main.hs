module Main (main) where

import Lib

main :: IO ()
main = do
  program_src <- getContents
  compileProgram program_src 2

hello_world :: String
hello_world = "// Hello world program\n\
\int main () {\n\
\  printString(\"Hello world!\") ;\n\
\  return 0 ;\n\
\}"