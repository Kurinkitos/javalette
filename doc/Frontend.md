# Tools used
For parsing I used bnfc, alex, and happy. 
The bnfc grammar is the provided one with an added typed expression which is used to type annotate the syntax tree.
Currently the type checker rejects any program which uses the annotations since they are not a part of the language,
and they would not do anything since there is no type inference in the language

# Design notes
For managing state during type checking I used the RWS monad from transformers, wrapped in ExceptT to handle errors.
Since I don't use the writer part of the RWS monad I could just use ReaderT State but the interface is nicer with RWS.
The reader holds function signatures since they are known and static, 
state holds a stack op Maps from JL identifiers to Types for local variables
All functions are checked separately since they only need to know the signatures of other functions.

For non void functions a separate pass checks if all branches return. 
This requires traversing the entire syntax tree en extra time, but I could not figure out a nice
way to do it without an extra pass. 

# Misc and ideas for improvements
Since type checking functions are done separately, it could fairly simply be run in parallel. 
Some of the expression checking has quite a bit of duplicated code, 
for example the binary operator are handled identically and it could probably be written more generically