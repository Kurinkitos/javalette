## File generated by the BNF Converter (bnfc 2.9.4.1).

# Makefile for building the parser and test program.

GHC        = ghc
HAPPY      = happy
HAPPY_OPTS = --array --info --ghc --coerce
ALEX       = alex
ALEX_OPTS  = --ghc

SUB_PATH   = $(shell stack path --local-install-root)

# List of goals not corresponding to file names.

.PHONY : all clean distclean compiler

# Default goal.

all : compiler

compiler : 
	stack build
	cp $(SUB_PATH)/bin/jlc-exe jlc


test : compiler
	./runtest.sh .
# Rules for building the parser.

src/Javalette/Abs.hs src/Javalette/Lex.x src/Javalette/Par.y src/Javalette/Print.hs src/Javalette/Test.hs : src/Javalette.cf
	bnfc --haskell -d Javalette.cf

%.hs : %.y
	${HAPPY} ${HAPPY_OPTS} $<

%.hs : %.x
	${ALEX} ${ALEX_OPTS} $<

src/Javalette/Test : src/Javalette/Abs.hs src/Javalette/Lex.hs src/Javalette/Par.hs src/Javalette/Print.hs src/Javalette/Test.hs
	${GHC} ${GHC_OPTS} $@

# Rules for cleaning generated files.

clean :
	-rm -f src/Javalette/*.hi src/Javalette/*.o src/Javalette/*.log src/Javalette/*.aux src/Javalette/*.dvi

distclean : clean
	-rm -f src/Javalette/Abs.hs src/Javalette/Abs.hs.bak src/Javalette/ComposOp.hs src/Javalette/ComposOp.hs.bak src/Javalette/Doc.txt src/Javalette/Doc.txt.bak src/Javalette/ErrM.hs src/Javalette/ErrM.hs.bak src/Javalette/Layout.hs src/Javalette/Layout.hs.bak src/Javalette/Lex.x src/Javalette/Lex.x.bak src/Javalette/Par.y src/Javalette/Par.y.bak src/Javalette/Print.hs src/Javalette/Print.hs.bak src/Javalette/Skel.hs src/Javalette/Skel.hs.bak src/Javalette/Test.hs src/Javalette/Test.hs.bak src/Javalette/XML.hs src/Javalette/XML.hs.bak src/Javalette/AST.agda src/Javalette/AST.agda.bak src/Javalette/Parser.agda src/Javalette/Parser.agda.bak src/Javalette/IOLib.agda src/Javalette/IOLib.agda.bak src/Javalette/Main.agda src/Javalette/Main.agda.bak src/Javalette/src/Javalette.dtd src/Javalette/src/Javalette.dtd.bak src/Javalette/Test src/Javalette/Lex.hs src/Javalette/Par.hs src/Javalette/Par.info src/Javalette/ParData.hs Makefile
	-rmdir -p src/Javalette/

# EOF
