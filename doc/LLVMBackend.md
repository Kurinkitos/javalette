# Libraries used
To represent LLVM IR I used llvm-hs-pure, 
which contains both types for LLVM IR structures and a monad IRBuilder which I use during code generation.
To turn the llvm structure into actual llvm ir code I used hs-llvm-pretty which outputs a string containing the IR.

# Notes
Unfortunately this choice of libraries caused me a bit of trouble, 
as I had written the type checker using very new versions of GHC and transformers. 
I hade to do some rewriting to get all the versions to match. 
I also ran into a bug with the IR builder overwriting terminator instructions, 
so there is a workaround in the codegen functions for If, If Else, and While. 
This bug is fixed in version 12 of llvm-hs but it is not fully released yet so I just worked around it.