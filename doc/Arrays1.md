# Grammar changes
Array types added, in the form of Type "[" "]"

For loops added

The length attribute implemented with c-style . selection. Currently is only checks for the specific
identifier "length", but this should be simpler to extend for full c-style structs

Assignments generalized from Ident = Expr to Expr6 = Expr, 
so that assignments can be made to expressions that produces an array, not just identifiers

# Notes
I modeled the arrays as Pascal style (length, [items]) structures, with the uninitialized value being just a zero. No bounds checking code is emitted. They are allocated with 'calloc', to make the memory zero

I had to rewrite the code generation a few times, since early assumptions I made turned out to not be true.
The biggest one was allowing expressions as L-Values, which I solved by adding a ValueKind parameter to
the cgExpr function to which makes variables and indexing operations return the address when set to LValue,
and does the load to get the value if set to RValue. 
Not super satisfied with it, but it was the best I could come up with.


Since it was not required for the extension I included no mechanism for freeing memory