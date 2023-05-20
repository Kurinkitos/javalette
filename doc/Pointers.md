# Grammar note
I spent a lot of time solving the conflicts that arose from adding Type ::= Ident to the grammar,
but with some help from Oskar on slack i found that the problem was that I had defined array types as
Type ::= Type "[" "]", instead of Type ::= Type "[]". 
Might be worth adding to the tips int the repo, because that was not very intuitive.

# Typechecker notes
The way I had previously done typechecking of expressions was not very extendable, 
so I refactored it to be more of a proper type checker.
The old one got the expected type as a argument and traversed down until it either reached the bottom,
or found something with the wrong type. 
The new one always gets to the bottom, and then compares types on the way up.
This was quite a big refactor, but only took a few hours thanks to haskell's type system and the test suite.

To handle user typedefs, 
I remove them with a desugarType function which turns typedefs into their underlying pointer types, 
otherwise it just returns the type. 
This is placed in relevant places in the typechecker, 
because it was the simplest with what I already had built.
But in hindsight a first desugar step would probably have been more robust, 
and possibly faster depending on how well ghc can remove the unnecessary calls

The symbols for the backend are extracted from the type-annotated AST, to get the desugared types.

# Backend notes
The backend extension was comparatively simple, 
I think mostly because of how much of the work I do in the typechecker
Before code generation I build a map with LLVM version of the structs and a map with precomputed offsets
for the different members. This made dereferencing very simple in code generation for function bodies.