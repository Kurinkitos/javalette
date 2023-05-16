{-# OPTIONS_GHC -w #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
{-# LANGUAGE PatternSynonyms #-}

module Javalette.Par
  ( happyError
  , myLexer
  , pProg
  ) where

import Prelude

import qualified Javalette.Abs
import Javalette.Lex
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 (Javalette.Abs.Ident)
	| HappyAbsSyn5 (Double)
	| HappyAbsSyn6 (Integer)
	| HappyAbsSyn7 (String)
	| HappyAbsSyn8 (Javalette.Abs.Prog)
	| HappyAbsSyn9 (Javalette.Abs.TopDef)
	| HappyAbsSyn10 ([Javalette.Abs.TopDef])
	| HappyAbsSyn11 (Javalette.Abs.Arg)
	| HappyAbsSyn12 ([Javalette.Abs.Arg])
	| HappyAbsSyn13 (Javalette.Abs.Blk)
	| HappyAbsSyn14 ([Javalette.Abs.Stmt])
	| HappyAbsSyn15 (Javalette.Abs.Stmt)
	| HappyAbsSyn16 (Javalette.Abs.Item)
	| HappyAbsSyn17 ([Javalette.Abs.Item])
	| HappyAbsSyn18 (Javalette.Abs.LVal)
	| HappyAbsSyn19 (Javalette.Abs.Type)
	| HappyAbsSyn20 ([Javalette.Abs.Type])
	| HappyAbsSyn21 (Javalette.Abs.Expr)
	| HappyAbsSyn31 ([Javalette.Abs.Expr])
	| HappyAbsSyn32 (Javalette.Abs.AddOp)
	| HappyAbsSyn33 (Javalette.Abs.MulOp)
	| HappyAbsSyn34 (Javalette.Abs.RelOp)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136 :: () => Prelude.Int -> ({-HappyReduction (Err) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81,
 happyReduce_82,
 happyReduce_83 :: () => ({-HappyReduction (Err) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,615) ([0,0,0,3072,17,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,4364,0,0,0,0,0,0,0,0,4096,8192,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,12288,68,0,0,2048,0,0,0,0,32,0,0,0,0,0,16,32,0,0,0,0,0,0,0,0,16384,0,0,0,0,1091,0,0,0,0,0,0,0,0,0,0,0,0,4164,60418,7807,0,0,2320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,0,0,16656,45064,31231,0,0,0,256,512,0,0,0,0,0,0,0,1024,17,0,0,0,0,0,0,0,4096,129,0,0,0,32768,4,0,0,0,640,3776,0,0,0,0,0,512,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,4096,65,10368,120,0,17408,16,2592,30,0,4352,4,33416,7,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,16,0,0,0,0,0,4288,1,0,4096,2113,10368,120,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1041,34816,1922,0,0,4,0,0,0,0,256,4,0,0,0,512,0,0,0,0,0,0,0,0,0,4096,0,0,0,16656,32768,30760,0,0,0,3072,17,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,4352,4,33416,7,0,1088,1,57506,1,0,0,0,0,0,0,4164,8192,7690,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1088,1,57506,1,0,0,0,0,0,0,0,0,0,0,0,1041,34816,1922,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,1088,1,57506,1,0,16656,32768,30760,0,0,0,16,0,0,0,512,0,0,0,0,8192,0,0,0,0,0,0,0,0,0,0,0,0,0,4352,4,33416,7,0,0,32,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,32768,0,0,1088,1,57506,1,0,0,2048,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,16384,516,0,0,0,0,0,0,0,0,32768,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,512,0,0,32,0,0,0,16384,260,41504,480,0,0,0,0,0,0,32768,0,0,0,0,4352,132,40955,7,0,0,8192,0,0,0,16656,45064,31231,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1088,1,57506,1,0,0,0,0,0,0,4164,8192,7690,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17408,528,32748,30,0,8192,0,0,0,0,1088,49185,59390,1,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProg","Ident","Double","Integer","String","Prog","TopDef","ListTopDef","Arg","ListArg","Blk","ListStmt","Stmt","Item","ListItem","LVal","Type","ListType","Expr7","Expr6","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","Expr8","Expr9","ListExpr","AddOp","MulOp","RelOp","'!'","'!='","'%'","'&&'","'('","')'","'*'","'+'","'++'","','","'-'","'--'","'.'","'/'","':'","';'","'<'","'<='","'='","'=='","'>'","'>='","'['","']'","'boolean'","'double'","'else'","'false'","'for'","'if'","'int'","'new'","'return'","'true'","'void'","'while'","'{'","'||'","'}'","L_Ident","L_doubl","L_integ","L_quoted","%eof"]
        bit_start = st Prelude.* 78
        bit_end = (st Prelude.+ 1) Prelude.* 78
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..77]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (59) = happyShift action_7
action_0 (60) = happyShift action_8
action_0 (65) = happyShift action_9
action_0 (69) = happyShift action_10
action_0 (8) = happyGoto action_3
action_0 (9) = happyGoto action_4
action_0 (10) = happyGoto action_5
action_0 (19) = happyGoto action_6
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (74) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (78) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (59) = happyShift action_7
action_4 (60) = happyShift action_8
action_4 (65) = happyShift action_9
action_4 (69) = happyShift action_10
action_4 (9) = happyGoto action_4
action_4 (10) = happyGoto action_13
action_4 (19) = happyGoto action_6
action_4 _ = happyReduce_7

action_5 _ = happyReduce_5

action_6 (57) = happyShift action_12
action_6 (74) = happyShift action_2
action_6 (4) = happyGoto action_11
action_6 _ = happyFail (happyExpListPerState 6)

action_7 _ = happyReduce_38

action_8 _ = happyReduce_37

action_9 _ = happyReduce_36

action_10 _ = happyReduce_39

action_11 (39) = happyShift action_15
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (58) = happyShift action_14
action_12 _ = happyFail (happyExpListPerState 12)

action_13 _ = happyReduce_8

action_14 _ = happyReduce_35

action_15 (59) = happyShift action_7
action_15 (60) = happyShift action_8
action_15 (65) = happyShift action_9
action_15 (69) = happyShift action_10
action_15 (11) = happyGoto action_16
action_15 (12) = happyGoto action_17
action_15 (19) = happyGoto action_18
action_15 _ = happyReduce_10

action_16 (44) = happyShift action_21
action_16 _ = happyReduce_11

action_17 (40) = happyShift action_20
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (57) = happyShift action_12
action_18 (74) = happyShift action_2
action_18 (4) = happyGoto action_19
action_18 _ = happyFail (happyExpListPerState 18)

action_19 _ = happyReduce_9

action_20 (71) = happyShift action_24
action_20 (13) = happyGoto action_23
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (59) = happyShift action_7
action_21 (60) = happyShift action_8
action_21 (65) = happyShift action_9
action_21 (69) = happyShift action_10
action_21 (11) = happyGoto action_16
action_21 (12) = happyGoto action_22
action_21 (19) = happyGoto action_18
action_21 _ = happyReduce_10

action_22 _ = happyReduce_12

action_23 _ = happyReduce_6

action_24 (35) = happyShift action_43
action_24 (39) = happyShift action_44
action_24 (45) = happyShift action_45
action_24 (50) = happyShift action_46
action_24 (59) = happyShift action_7
action_24 (60) = happyShift action_8
action_24 (62) = happyShift action_47
action_24 (63) = happyShift action_48
action_24 (64) = happyShift action_49
action_24 (65) = happyShift action_9
action_24 (66) = happyShift action_50
action_24 (67) = happyShift action_51
action_24 (68) = happyShift action_52
action_24 (69) = happyShift action_10
action_24 (70) = happyShift action_53
action_24 (71) = happyShift action_24
action_24 (74) = happyShift action_2
action_24 (75) = happyShift action_54
action_24 (76) = happyShift action_55
action_24 (77) = happyShift action_56
action_24 (4) = happyGoto action_25
action_24 (5) = happyGoto action_26
action_24 (6) = happyGoto action_27
action_24 (7) = happyGoto action_28
action_24 (13) = happyGoto action_29
action_24 (14) = happyGoto action_30
action_24 (15) = happyGoto action_31
action_24 (19) = happyGoto action_32
action_24 (21) = happyGoto action_33
action_24 (22) = happyGoto action_34
action_24 (23) = happyGoto action_35
action_24 (24) = happyGoto action_36
action_24 (25) = happyGoto action_37
action_24 (26) = happyGoto action_38
action_24 (27) = happyGoto action_39
action_24 (28) = happyGoto action_40
action_24 (29) = happyGoto action_41
action_24 (30) = happyGoto action_42
action_24 _ = happyReduce_14

action_25 (39) = happyShift action_93
action_25 (43) = happyShift action_94
action_25 (46) = happyShift action_95
action_25 _ = happyReduce_47

action_26 _ = happyReduce_49

action_27 _ = happyReduce_48

action_28 _ = happyReduce_53

action_29 _ = happyReduce_17

action_30 (73) = happyShift action_92
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (35) = happyShift action_43
action_31 (39) = happyShift action_44
action_31 (45) = happyShift action_45
action_31 (50) = happyShift action_46
action_31 (59) = happyShift action_7
action_31 (60) = happyShift action_8
action_31 (62) = happyShift action_47
action_31 (63) = happyShift action_48
action_31 (64) = happyShift action_49
action_31 (65) = happyShift action_9
action_31 (66) = happyShift action_50
action_31 (67) = happyShift action_51
action_31 (68) = happyShift action_52
action_31 (69) = happyShift action_10
action_31 (70) = happyShift action_53
action_31 (71) = happyShift action_24
action_31 (74) = happyShift action_2
action_31 (75) = happyShift action_54
action_31 (76) = happyShift action_55
action_31 (77) = happyShift action_56
action_31 (4) = happyGoto action_25
action_31 (5) = happyGoto action_26
action_31 (6) = happyGoto action_27
action_31 (7) = happyGoto action_28
action_31 (13) = happyGoto action_29
action_31 (14) = happyGoto action_91
action_31 (15) = happyGoto action_31
action_31 (19) = happyGoto action_32
action_31 (21) = happyGoto action_33
action_31 (22) = happyGoto action_34
action_31 (23) = happyGoto action_35
action_31 (24) = happyGoto action_36
action_31 (25) = happyGoto action_37
action_31 (26) = happyGoto action_38
action_31 (27) = happyGoto action_39
action_31 (28) = happyGoto action_40
action_31 (29) = happyGoto action_41
action_31 (30) = happyGoto action_42
action_31 _ = happyReduce_14

action_32 (57) = happyShift action_12
action_32 (74) = happyShift action_2
action_32 (4) = happyGoto action_88
action_32 (16) = happyGoto action_89
action_32 (17) = happyGoto action_90
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_54

action_34 (47) = happyShift action_85
action_34 (53) = happyShift action_86
action_34 (57) = happyShift action_87
action_34 _ = happyReduce_57

action_35 _ = happyReduce_59

action_36 (37) = happyShift action_82
action_36 (41) = happyShift action_83
action_36 (48) = happyShift action_84
action_36 (33) = happyGoto action_81
action_36 _ = happyReduce_61

action_37 (42) = happyShift action_79
action_37 (45) = happyShift action_80
action_37 (32) = happyGoto action_78
action_37 _ = happyReduce_63

action_38 (36) = happyShift action_71
action_38 (38) = happyShift action_72
action_38 (51) = happyShift action_73
action_38 (52) = happyShift action_74
action_38 (54) = happyShift action_75
action_38 (55) = happyShift action_76
action_38 (56) = happyShift action_77
action_38 (34) = happyGoto action_70
action_38 _ = happyReduce_65

action_39 (72) = happyShift action_69
action_39 _ = happyReduce_67

action_40 (50) = happyShift action_68
action_40 _ = happyFail (happyExpListPerState 40)

action_41 _ = happyReduce_44

action_42 _ = happyReduce_68

action_43 (35) = happyShift action_43
action_43 (39) = happyShift action_44
action_43 (45) = happyShift action_45
action_43 (62) = happyShift action_47
action_43 (66) = happyShift action_50
action_43 (68) = happyShift action_52
action_43 (74) = happyShift action_2
action_43 (75) = happyShift action_54
action_43 (76) = happyShift action_55
action_43 (77) = happyShift action_56
action_43 (4) = happyGoto action_58
action_43 (5) = happyGoto action_26
action_43 (6) = happyGoto action_27
action_43 (7) = happyGoto action_28
action_43 (21) = happyGoto action_33
action_43 (22) = happyGoto action_59
action_43 (23) = happyGoto action_67
action_43 (29) = happyGoto action_41
action_43 (30) = happyGoto action_42
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (35) = happyShift action_43
action_44 (39) = happyShift action_44
action_44 (45) = happyShift action_45
action_44 (62) = happyShift action_47
action_44 (66) = happyShift action_50
action_44 (68) = happyShift action_52
action_44 (74) = happyShift action_2
action_44 (75) = happyShift action_54
action_44 (76) = happyShift action_55
action_44 (77) = happyShift action_56
action_44 (4) = happyGoto action_58
action_44 (5) = happyGoto action_26
action_44 (6) = happyGoto action_27
action_44 (7) = happyGoto action_28
action_44 (21) = happyGoto action_33
action_44 (22) = happyGoto action_59
action_44 (23) = happyGoto action_35
action_44 (24) = happyGoto action_36
action_44 (25) = happyGoto action_37
action_44 (26) = happyGoto action_38
action_44 (27) = happyGoto action_39
action_44 (28) = happyGoto action_66
action_44 (29) = happyGoto action_41
action_44 (30) = happyGoto action_42
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (35) = happyShift action_43
action_45 (39) = happyShift action_44
action_45 (45) = happyShift action_45
action_45 (62) = happyShift action_47
action_45 (66) = happyShift action_50
action_45 (68) = happyShift action_52
action_45 (74) = happyShift action_2
action_45 (75) = happyShift action_54
action_45 (76) = happyShift action_55
action_45 (77) = happyShift action_56
action_45 (4) = happyGoto action_58
action_45 (5) = happyGoto action_26
action_45 (6) = happyGoto action_27
action_45 (7) = happyGoto action_28
action_45 (21) = happyGoto action_33
action_45 (22) = happyGoto action_59
action_45 (23) = happyGoto action_65
action_45 (29) = happyGoto action_41
action_45 (30) = happyGoto action_42
action_45 _ = happyFail (happyExpListPerState 45)

action_46 _ = happyReduce_16

action_47 _ = happyReduce_51

action_48 (39) = happyShift action_64
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (39) = happyShift action_63
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (59) = happyShift action_7
action_50 (60) = happyShift action_8
action_50 (65) = happyShift action_9
action_50 (69) = happyShift action_10
action_50 (19) = happyGoto action_62
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (35) = happyShift action_43
action_51 (39) = happyShift action_44
action_51 (45) = happyShift action_45
action_51 (50) = happyShift action_61
action_51 (62) = happyShift action_47
action_51 (66) = happyShift action_50
action_51 (68) = happyShift action_52
action_51 (74) = happyShift action_2
action_51 (75) = happyShift action_54
action_51 (76) = happyShift action_55
action_51 (77) = happyShift action_56
action_51 (4) = happyGoto action_58
action_51 (5) = happyGoto action_26
action_51 (6) = happyGoto action_27
action_51 (7) = happyGoto action_28
action_51 (21) = happyGoto action_33
action_51 (22) = happyGoto action_59
action_51 (23) = happyGoto action_35
action_51 (24) = happyGoto action_36
action_51 (25) = happyGoto action_37
action_51 (26) = happyGoto action_38
action_51 (27) = happyGoto action_39
action_51 (28) = happyGoto action_60
action_51 (29) = happyGoto action_41
action_51 (30) = happyGoto action_42
action_51 _ = happyFail (happyExpListPerState 51)

action_52 _ = happyReduce_50

action_53 (39) = happyShift action_57
action_53 _ = happyFail (happyExpListPerState 53)

action_54 _ = happyReduce_2

action_55 _ = happyReduce_3

action_56 _ = happyReduce_4

action_57 (35) = happyShift action_43
action_57 (39) = happyShift action_44
action_57 (45) = happyShift action_45
action_57 (62) = happyShift action_47
action_57 (66) = happyShift action_50
action_57 (68) = happyShift action_52
action_57 (74) = happyShift action_2
action_57 (75) = happyShift action_54
action_57 (76) = happyShift action_55
action_57 (77) = happyShift action_56
action_57 (4) = happyGoto action_58
action_57 (5) = happyGoto action_26
action_57 (6) = happyGoto action_27
action_57 (7) = happyGoto action_28
action_57 (21) = happyGoto action_33
action_57 (22) = happyGoto action_59
action_57 (23) = happyGoto action_35
action_57 (24) = happyGoto action_36
action_57 (25) = happyGoto action_37
action_57 (26) = happyGoto action_38
action_57 (27) = happyGoto action_39
action_57 (28) = happyGoto action_116
action_57 (29) = happyGoto action_41
action_57 (30) = happyGoto action_42
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (39) = happyShift action_93
action_58 _ = happyReduce_47

action_59 (47) = happyShift action_85
action_59 (57) = happyShift action_87
action_59 _ = happyReduce_57

action_60 (50) = happyShift action_115
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_23

action_62 (57) = happyShift action_114
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (35) = happyShift action_43
action_63 (39) = happyShift action_44
action_63 (45) = happyShift action_45
action_63 (62) = happyShift action_47
action_63 (66) = happyShift action_50
action_63 (68) = happyShift action_52
action_63 (74) = happyShift action_2
action_63 (75) = happyShift action_54
action_63 (76) = happyShift action_55
action_63 (77) = happyShift action_56
action_63 (4) = happyGoto action_58
action_63 (5) = happyGoto action_26
action_63 (6) = happyGoto action_27
action_63 (7) = happyGoto action_28
action_63 (21) = happyGoto action_33
action_63 (22) = happyGoto action_59
action_63 (23) = happyGoto action_35
action_63 (24) = happyGoto action_36
action_63 (25) = happyGoto action_37
action_63 (26) = happyGoto action_38
action_63 (27) = happyGoto action_39
action_63 (28) = happyGoto action_113
action_63 (29) = happyGoto action_41
action_63 (30) = happyGoto action_42
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (59) = happyShift action_7
action_64 (60) = happyShift action_8
action_64 (65) = happyShift action_9
action_64 (69) = happyShift action_10
action_64 (19) = happyGoto action_112
action_64 _ = happyFail (happyExpListPerState 64)

action_65 _ = happyReduce_55

action_66 (40) = happyShift action_111
action_66 _ = happyFail (happyExpListPerState 66)

action_67 _ = happyReduce_56

action_68 _ = happyReduce_28

action_69 (35) = happyShift action_43
action_69 (39) = happyShift action_44
action_69 (45) = happyShift action_45
action_69 (62) = happyShift action_47
action_69 (66) = happyShift action_50
action_69 (68) = happyShift action_52
action_69 (74) = happyShift action_2
action_69 (75) = happyShift action_54
action_69 (76) = happyShift action_55
action_69 (77) = happyShift action_56
action_69 (4) = happyGoto action_58
action_69 (5) = happyGoto action_26
action_69 (6) = happyGoto action_27
action_69 (7) = happyGoto action_28
action_69 (21) = happyGoto action_33
action_69 (22) = happyGoto action_59
action_69 (23) = happyGoto action_35
action_69 (24) = happyGoto action_36
action_69 (25) = happyGoto action_37
action_69 (26) = happyGoto action_38
action_69 (27) = happyGoto action_39
action_69 (28) = happyGoto action_110
action_69 (29) = happyGoto action_41
action_69 (30) = happyGoto action_42
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (35) = happyShift action_43
action_70 (39) = happyShift action_44
action_70 (45) = happyShift action_45
action_70 (62) = happyShift action_47
action_70 (66) = happyShift action_50
action_70 (68) = happyShift action_52
action_70 (74) = happyShift action_2
action_70 (75) = happyShift action_54
action_70 (76) = happyShift action_55
action_70 (77) = happyShift action_56
action_70 (4) = happyGoto action_58
action_70 (5) = happyGoto action_26
action_70 (6) = happyGoto action_27
action_70 (7) = happyGoto action_28
action_70 (21) = happyGoto action_33
action_70 (22) = happyGoto action_59
action_70 (23) = happyGoto action_35
action_70 (24) = happyGoto action_36
action_70 (25) = happyGoto action_109
action_70 (29) = happyGoto action_41
action_70 (30) = happyGoto action_42
action_70 _ = happyFail (happyExpListPerState 70)

action_71 _ = happyReduce_83

action_72 (35) = happyShift action_43
action_72 (39) = happyShift action_44
action_72 (45) = happyShift action_45
action_72 (62) = happyShift action_47
action_72 (66) = happyShift action_50
action_72 (68) = happyShift action_52
action_72 (74) = happyShift action_2
action_72 (75) = happyShift action_54
action_72 (76) = happyShift action_55
action_72 (77) = happyShift action_56
action_72 (4) = happyGoto action_58
action_72 (5) = happyGoto action_26
action_72 (6) = happyGoto action_27
action_72 (7) = happyGoto action_28
action_72 (21) = happyGoto action_33
action_72 (22) = happyGoto action_59
action_72 (23) = happyGoto action_35
action_72 (24) = happyGoto action_36
action_72 (25) = happyGoto action_37
action_72 (26) = happyGoto action_38
action_72 (27) = happyGoto action_108
action_72 (29) = happyGoto action_41
action_72 (30) = happyGoto action_42
action_72 _ = happyFail (happyExpListPerState 72)

action_73 _ = happyReduce_78

action_74 _ = happyReduce_79

action_75 _ = happyReduce_82

action_76 _ = happyReduce_80

action_77 _ = happyReduce_81

action_78 (35) = happyShift action_43
action_78 (39) = happyShift action_44
action_78 (45) = happyShift action_45
action_78 (62) = happyShift action_47
action_78 (66) = happyShift action_50
action_78 (68) = happyShift action_52
action_78 (74) = happyShift action_2
action_78 (75) = happyShift action_54
action_78 (76) = happyShift action_55
action_78 (77) = happyShift action_56
action_78 (4) = happyGoto action_58
action_78 (5) = happyGoto action_26
action_78 (6) = happyGoto action_27
action_78 (7) = happyGoto action_28
action_78 (21) = happyGoto action_33
action_78 (22) = happyGoto action_59
action_78 (23) = happyGoto action_35
action_78 (24) = happyGoto action_107
action_78 (29) = happyGoto action_41
action_78 (30) = happyGoto action_42
action_78 _ = happyFail (happyExpListPerState 78)

action_79 _ = happyReduce_73

action_80 _ = happyReduce_74

action_81 (35) = happyShift action_43
action_81 (39) = happyShift action_44
action_81 (45) = happyShift action_45
action_81 (62) = happyShift action_47
action_81 (66) = happyShift action_50
action_81 (68) = happyShift action_52
action_81 (74) = happyShift action_2
action_81 (75) = happyShift action_54
action_81 (76) = happyShift action_55
action_81 (77) = happyShift action_56
action_81 (4) = happyGoto action_58
action_81 (5) = happyGoto action_26
action_81 (6) = happyGoto action_27
action_81 (7) = happyGoto action_28
action_81 (21) = happyGoto action_33
action_81 (22) = happyGoto action_59
action_81 (23) = happyGoto action_106
action_81 (29) = happyGoto action_41
action_81 (30) = happyGoto action_42
action_81 _ = happyFail (happyExpListPerState 81)

action_82 _ = happyReduce_77

action_83 _ = happyReduce_75

action_84 _ = happyReduce_76

action_85 (74) = happyShift action_2
action_85 (4) = happyGoto action_105
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (35) = happyShift action_43
action_86 (39) = happyShift action_44
action_86 (45) = happyShift action_45
action_86 (62) = happyShift action_47
action_86 (66) = happyShift action_50
action_86 (68) = happyShift action_52
action_86 (74) = happyShift action_2
action_86 (75) = happyShift action_54
action_86 (76) = happyShift action_55
action_86 (77) = happyShift action_56
action_86 (4) = happyGoto action_58
action_86 (5) = happyGoto action_26
action_86 (6) = happyGoto action_27
action_86 (7) = happyGoto action_28
action_86 (21) = happyGoto action_33
action_86 (22) = happyGoto action_59
action_86 (23) = happyGoto action_35
action_86 (24) = happyGoto action_36
action_86 (25) = happyGoto action_37
action_86 (26) = happyGoto action_38
action_86 (27) = happyGoto action_39
action_86 (28) = happyGoto action_104
action_86 (29) = happyGoto action_41
action_86 (30) = happyGoto action_42
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (35) = happyShift action_43
action_87 (39) = happyShift action_44
action_87 (45) = happyShift action_45
action_87 (62) = happyShift action_47
action_87 (66) = happyShift action_50
action_87 (68) = happyShift action_52
action_87 (74) = happyShift action_2
action_87 (75) = happyShift action_54
action_87 (76) = happyShift action_55
action_87 (77) = happyShift action_56
action_87 (4) = happyGoto action_58
action_87 (5) = happyGoto action_26
action_87 (6) = happyGoto action_27
action_87 (7) = happyGoto action_28
action_87 (21) = happyGoto action_33
action_87 (22) = happyGoto action_59
action_87 (23) = happyGoto action_35
action_87 (24) = happyGoto action_36
action_87 (25) = happyGoto action_37
action_87 (26) = happyGoto action_38
action_87 (27) = happyGoto action_39
action_87 (28) = happyGoto action_103
action_87 (29) = happyGoto action_41
action_87 (30) = happyGoto action_42
action_87 _ = happyFail (happyExpListPerState 87)

action_88 (53) = happyShift action_102
action_88 _ = happyReduce_29

action_89 (44) = happyShift action_101
action_89 _ = happyReduce_31

action_90 (50) = happyShift action_100
action_90 _ = happyFail (happyExpListPerState 90)

action_91 _ = happyReduce_15

action_92 _ = happyReduce_13

action_93 (35) = happyShift action_43
action_93 (39) = happyShift action_44
action_93 (45) = happyShift action_45
action_93 (62) = happyShift action_47
action_93 (66) = happyShift action_50
action_93 (68) = happyShift action_52
action_93 (74) = happyShift action_2
action_93 (75) = happyShift action_54
action_93 (76) = happyShift action_55
action_93 (77) = happyShift action_56
action_93 (4) = happyGoto action_58
action_93 (5) = happyGoto action_26
action_93 (6) = happyGoto action_27
action_93 (7) = happyGoto action_28
action_93 (21) = happyGoto action_33
action_93 (22) = happyGoto action_59
action_93 (23) = happyGoto action_35
action_93 (24) = happyGoto action_36
action_93 (25) = happyGoto action_37
action_93 (26) = happyGoto action_38
action_93 (27) = happyGoto action_39
action_93 (28) = happyGoto action_98
action_93 (29) = happyGoto action_41
action_93 (30) = happyGoto action_42
action_93 (31) = happyGoto action_99
action_93 _ = happyReduce_70

action_94 (50) = happyShift action_97
action_94 _ = happyFail (happyExpListPerState 94)

action_95 (50) = happyShift action_96
action_95 _ = happyFail (happyExpListPerState 95)

action_96 _ = happyReduce_21

action_97 _ = happyReduce_20

action_98 (44) = happyShift action_126
action_98 _ = happyReduce_71

action_99 (40) = happyShift action_125
action_99 _ = happyFail (happyExpListPerState 99)

action_100 _ = happyReduce_18

action_101 (74) = happyShift action_2
action_101 (4) = happyGoto action_88
action_101 (16) = happyGoto action_89
action_101 (17) = happyGoto action_124
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (35) = happyShift action_43
action_102 (39) = happyShift action_44
action_102 (45) = happyShift action_45
action_102 (62) = happyShift action_47
action_102 (66) = happyShift action_50
action_102 (68) = happyShift action_52
action_102 (74) = happyShift action_2
action_102 (75) = happyShift action_54
action_102 (76) = happyShift action_55
action_102 (77) = happyShift action_56
action_102 (4) = happyGoto action_58
action_102 (5) = happyGoto action_26
action_102 (6) = happyGoto action_27
action_102 (7) = happyGoto action_28
action_102 (21) = happyGoto action_33
action_102 (22) = happyGoto action_59
action_102 (23) = happyGoto action_35
action_102 (24) = happyGoto action_36
action_102 (25) = happyGoto action_37
action_102 (26) = happyGoto action_38
action_102 (27) = happyGoto action_39
action_102 (28) = happyGoto action_123
action_102 (29) = happyGoto action_41
action_102 (30) = happyGoto action_42
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (58) = happyShift action_122
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (50) = happyShift action_121
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_46

action_106 _ = happyReduce_58

action_107 (37) = happyShift action_82
action_107 (41) = happyShift action_83
action_107 (48) = happyShift action_84
action_107 (33) = happyGoto action_81
action_107 _ = happyReduce_60

action_108 _ = happyReduce_64

action_109 (42) = happyShift action_79
action_109 (45) = happyShift action_80
action_109 (32) = happyGoto action_78
action_109 _ = happyReduce_62

action_110 _ = happyReduce_66

action_111 _ = happyReduce_69

action_112 (57) = happyShift action_12
action_112 (74) = happyShift action_2
action_112 (4) = happyGoto action_120
action_112 _ = happyFail (happyExpListPerState 112)

action_113 (40) = happyShift action_119
action_113 _ = happyFail (happyExpListPerState 113)

action_114 (35) = happyShift action_43
action_114 (39) = happyShift action_44
action_114 (45) = happyShift action_45
action_114 (58) = happyShift action_14
action_114 (62) = happyShift action_47
action_114 (66) = happyShift action_50
action_114 (68) = happyShift action_52
action_114 (74) = happyShift action_2
action_114 (75) = happyShift action_54
action_114 (76) = happyShift action_55
action_114 (77) = happyShift action_56
action_114 (4) = happyGoto action_58
action_114 (5) = happyGoto action_26
action_114 (6) = happyGoto action_27
action_114 (7) = happyGoto action_28
action_114 (21) = happyGoto action_33
action_114 (22) = happyGoto action_59
action_114 (23) = happyGoto action_35
action_114 (24) = happyGoto action_36
action_114 (25) = happyGoto action_37
action_114 (26) = happyGoto action_38
action_114 (27) = happyGoto action_39
action_114 (28) = happyGoto action_118
action_114 (29) = happyGoto action_41
action_114 (30) = happyGoto action_42
action_114 _ = happyFail (happyExpListPerState 114)

action_115 _ = happyReduce_22

action_116 (40) = happyShift action_117
action_116 _ = happyFail (happyExpListPerState 116)

action_117 (35) = happyShift action_43
action_117 (39) = happyShift action_44
action_117 (45) = happyShift action_45
action_117 (50) = happyShift action_46
action_117 (59) = happyShift action_7
action_117 (60) = happyShift action_8
action_117 (62) = happyShift action_47
action_117 (63) = happyShift action_48
action_117 (64) = happyShift action_49
action_117 (65) = happyShift action_9
action_117 (66) = happyShift action_50
action_117 (67) = happyShift action_51
action_117 (68) = happyShift action_52
action_117 (69) = happyShift action_10
action_117 (70) = happyShift action_53
action_117 (71) = happyShift action_24
action_117 (74) = happyShift action_2
action_117 (75) = happyShift action_54
action_117 (76) = happyShift action_55
action_117 (77) = happyShift action_56
action_117 (4) = happyGoto action_25
action_117 (5) = happyGoto action_26
action_117 (6) = happyGoto action_27
action_117 (7) = happyGoto action_28
action_117 (13) = happyGoto action_29
action_117 (15) = happyGoto action_131
action_117 (19) = happyGoto action_32
action_117 (21) = happyGoto action_33
action_117 (22) = happyGoto action_34
action_117 (23) = happyGoto action_35
action_117 (24) = happyGoto action_36
action_117 (25) = happyGoto action_37
action_117 (26) = happyGoto action_38
action_117 (27) = happyGoto action_39
action_117 (28) = happyGoto action_40
action_117 (29) = happyGoto action_41
action_117 (30) = happyGoto action_42
action_117 _ = happyFail (happyExpListPerState 117)

action_118 (58) = happyShift action_130
action_118 _ = happyFail (happyExpListPerState 118)

action_119 (35) = happyShift action_43
action_119 (39) = happyShift action_44
action_119 (45) = happyShift action_45
action_119 (50) = happyShift action_46
action_119 (59) = happyShift action_7
action_119 (60) = happyShift action_8
action_119 (62) = happyShift action_47
action_119 (63) = happyShift action_48
action_119 (64) = happyShift action_49
action_119 (65) = happyShift action_9
action_119 (66) = happyShift action_50
action_119 (67) = happyShift action_51
action_119 (68) = happyShift action_52
action_119 (69) = happyShift action_10
action_119 (70) = happyShift action_53
action_119 (71) = happyShift action_24
action_119 (74) = happyShift action_2
action_119 (75) = happyShift action_54
action_119 (76) = happyShift action_55
action_119 (77) = happyShift action_56
action_119 (4) = happyGoto action_25
action_119 (5) = happyGoto action_26
action_119 (6) = happyGoto action_27
action_119 (7) = happyGoto action_28
action_119 (13) = happyGoto action_29
action_119 (15) = happyGoto action_129
action_119 (19) = happyGoto action_32
action_119 (21) = happyGoto action_33
action_119 (22) = happyGoto action_34
action_119 (23) = happyGoto action_35
action_119 (24) = happyGoto action_36
action_119 (25) = happyGoto action_37
action_119 (26) = happyGoto action_38
action_119 (27) = happyGoto action_39
action_119 (28) = happyGoto action_40
action_119 (29) = happyGoto action_41
action_119 (30) = happyGoto action_42
action_119 _ = happyFail (happyExpListPerState 119)

action_120 (49) = happyShift action_128
action_120 _ = happyFail (happyExpListPerState 120)

action_121 _ = happyReduce_19

action_122 _ = happyReduce_45

action_123 _ = happyReduce_30

action_124 _ = happyReduce_32

action_125 _ = happyReduce_52

action_126 (35) = happyShift action_43
action_126 (39) = happyShift action_44
action_126 (45) = happyShift action_45
action_126 (62) = happyShift action_47
action_126 (66) = happyShift action_50
action_126 (68) = happyShift action_52
action_126 (74) = happyShift action_2
action_126 (75) = happyShift action_54
action_126 (76) = happyShift action_55
action_126 (77) = happyShift action_56
action_126 (4) = happyGoto action_58
action_126 (5) = happyGoto action_26
action_126 (6) = happyGoto action_27
action_126 (7) = happyGoto action_28
action_126 (21) = happyGoto action_33
action_126 (22) = happyGoto action_59
action_126 (23) = happyGoto action_35
action_126 (24) = happyGoto action_36
action_126 (25) = happyGoto action_37
action_126 (26) = happyGoto action_38
action_126 (27) = happyGoto action_39
action_126 (28) = happyGoto action_98
action_126 (29) = happyGoto action_41
action_126 (30) = happyGoto action_42
action_126 (31) = happyGoto action_127
action_126 _ = happyReduce_70

action_127 _ = happyReduce_72

action_128 (35) = happyShift action_43
action_128 (39) = happyShift action_44
action_128 (45) = happyShift action_45
action_128 (62) = happyShift action_47
action_128 (66) = happyShift action_50
action_128 (68) = happyShift action_52
action_128 (74) = happyShift action_2
action_128 (75) = happyShift action_54
action_128 (76) = happyShift action_55
action_128 (77) = happyShift action_56
action_128 (4) = happyGoto action_58
action_128 (5) = happyGoto action_26
action_128 (6) = happyGoto action_27
action_128 (7) = happyGoto action_28
action_128 (21) = happyGoto action_33
action_128 (22) = happyGoto action_59
action_128 (23) = happyGoto action_35
action_128 (24) = happyGoto action_36
action_128 (25) = happyGoto action_37
action_128 (26) = happyGoto action_38
action_128 (27) = happyGoto action_39
action_128 (28) = happyGoto action_133
action_128 (29) = happyGoto action_41
action_128 (30) = happyGoto action_42
action_128 _ = happyFail (happyExpListPerState 128)

action_129 (61) = happyShift action_132
action_129 _ = happyReduce_24

action_130 _ = happyReduce_43

action_131 _ = happyReduce_26

action_132 (35) = happyShift action_43
action_132 (39) = happyShift action_44
action_132 (45) = happyShift action_45
action_132 (50) = happyShift action_46
action_132 (59) = happyShift action_7
action_132 (60) = happyShift action_8
action_132 (62) = happyShift action_47
action_132 (63) = happyShift action_48
action_132 (64) = happyShift action_49
action_132 (65) = happyShift action_9
action_132 (66) = happyShift action_50
action_132 (67) = happyShift action_51
action_132 (68) = happyShift action_52
action_132 (69) = happyShift action_10
action_132 (70) = happyShift action_53
action_132 (71) = happyShift action_24
action_132 (74) = happyShift action_2
action_132 (75) = happyShift action_54
action_132 (76) = happyShift action_55
action_132 (77) = happyShift action_56
action_132 (4) = happyGoto action_25
action_132 (5) = happyGoto action_26
action_132 (6) = happyGoto action_27
action_132 (7) = happyGoto action_28
action_132 (13) = happyGoto action_29
action_132 (15) = happyGoto action_135
action_132 (19) = happyGoto action_32
action_132 (21) = happyGoto action_33
action_132 (22) = happyGoto action_34
action_132 (23) = happyGoto action_35
action_132 (24) = happyGoto action_36
action_132 (25) = happyGoto action_37
action_132 (26) = happyGoto action_38
action_132 (27) = happyGoto action_39
action_132 (28) = happyGoto action_40
action_132 (29) = happyGoto action_41
action_132 (30) = happyGoto action_42
action_132 _ = happyFail (happyExpListPerState 132)

action_133 (40) = happyShift action_134
action_133 _ = happyFail (happyExpListPerState 133)

action_134 (35) = happyShift action_43
action_134 (39) = happyShift action_44
action_134 (45) = happyShift action_45
action_134 (50) = happyShift action_46
action_134 (59) = happyShift action_7
action_134 (60) = happyShift action_8
action_134 (62) = happyShift action_47
action_134 (63) = happyShift action_48
action_134 (64) = happyShift action_49
action_134 (65) = happyShift action_9
action_134 (66) = happyShift action_50
action_134 (67) = happyShift action_51
action_134 (68) = happyShift action_52
action_134 (69) = happyShift action_10
action_134 (70) = happyShift action_53
action_134 (71) = happyShift action_24
action_134 (74) = happyShift action_2
action_134 (75) = happyShift action_54
action_134 (76) = happyShift action_55
action_134 (77) = happyShift action_56
action_134 (4) = happyGoto action_25
action_134 (5) = happyGoto action_26
action_134 (6) = happyGoto action_27
action_134 (7) = happyGoto action_28
action_134 (13) = happyGoto action_29
action_134 (15) = happyGoto action_136
action_134 (19) = happyGoto action_32
action_134 (21) = happyGoto action_33
action_134 (22) = happyGoto action_34
action_134 (23) = happyGoto action_35
action_134 (24) = happyGoto action_36
action_134 (25) = happyGoto action_37
action_134 (26) = happyGoto action_38
action_134 (27) = happyGoto action_39
action_134 (28) = happyGoto action_40
action_134 (29) = happyGoto action_41
action_134 (30) = happyGoto action_42
action_134 _ = happyFail (happyExpListPerState 134)

action_135 _ = happyReduce_25

action_136 _ = happyReduce_27

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal (PT _ (TV happy_var_1)))
	 =  HappyAbsSyn4
		 (Javalette.Abs.Ident happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyTerminal (PT _ (TD happy_var_1)))
	 =  HappyAbsSyn5
		 ((read happy_var_1) :: Double
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  6 happyReduction_3
happyReduction_3 (HappyTerminal (PT _ (TI happy_var_1)))
	 =  HappyAbsSyn6
		 ((read happy_var_1) :: Integer
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  7 happyReduction_4
happyReduction_4 (HappyTerminal (PT _ (TL happy_var_1)))
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_1  8 happyReduction_5
happyReduction_5 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn8
		 (Javalette.Abs.Program happy_var_1
	)
happyReduction_5 _  = notHappyAtAll 

happyReduce_6 = happyReduce 6 9 happyReduction_6
happyReduction_6 ((HappyAbsSyn13  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn19  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (Javalette.Abs.FnDef happy_var_1 happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_1  10 happyReduction_7
happyReduction_7 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 ((:[]) happy_var_1
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  10 happyReduction_8
happyReduction_8 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 ((:) happy_var_1 happy_var_2
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_2  11 happyReduction_9
happyReduction_9 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn11
		 (Javalette.Abs.Argument happy_var_1 happy_var_2
	)
happyReduction_9 _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_0  12 happyReduction_10
happyReduction_10  =  HappyAbsSyn12
		 ([]
	)

happyReduce_11 = happySpecReduce_1  12 happyReduction_11
happyReduction_11 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 ((:[]) happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  12 happyReduction_12
happyReduction_12 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  13 happyReduction_13
happyReduction_13 _
	(HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (Javalette.Abs.Block happy_var_2
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_0  14 happyReduction_14
happyReduction_14  =  HappyAbsSyn14
		 ([]
	)

happyReduce_15 = happySpecReduce_2  14 happyReduction_15
happyReduction_15 (HappyAbsSyn14  happy_var_2)
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 ((:) happy_var_1 happy_var_2
	)
happyReduction_15 _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  15 happyReduction_16
happyReduction_16 _
	 =  HappyAbsSyn15
		 (Javalette.Abs.Empty
	)

happyReduce_17 = happySpecReduce_1  15 happyReduction_17
happyReduction_17 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.BStmt happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  15 happyReduction_18
happyReduction_18 _
	(HappyAbsSyn17  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.Decl happy_var_1 happy_var_2
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happyReduce 4 15 happyReduction_19
happyReduction_19 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.Ass happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_20 = happySpecReduce_3  15 happyReduction_20
happyReduction_20 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.Incr happy_var_1
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  15 happyReduction_21
happyReduction_21 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.Decr happy_var_1
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  15 happyReduction_22
happyReduction_22 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (Javalette.Abs.Ret happy_var_2
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  15 happyReduction_23
happyReduction_23 _
	_
	 =  HappyAbsSyn15
		 (Javalette.Abs.VRet
	)

happyReduce_24 = happyReduce 5 15 happyReduction_24
happyReduction_24 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.Cond happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_25 = happyReduce 7 15 happyReduction_25
happyReduction_25 ((HappyAbsSyn15  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.CondElse happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_26 = happyReduce 5 15 happyReduction_26
happyReduction_26 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.While happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_27 = happyReduce 8 15 happyReduction_27
happyReduction_27 ((HappyAbsSyn15  happy_var_8) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_4) `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.For happy_var_3 happy_var_4 happy_var_6 happy_var_8
	) `HappyStk` happyRest

happyReduce_28 = happySpecReduce_2  15 happyReduction_28
happyReduction_28 _
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.SExp happy_var_1
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  16 happyReduction_29
happyReduction_29 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn16
		 (Javalette.Abs.NoInitVar happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  16 happyReduction_30
happyReduction_30 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn16
		 (Javalette.Abs.Init happy_var_1 happy_var_3
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  17 happyReduction_31
happyReduction_31 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 ((:[]) happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_3  17 happyReduction_32
happyReduction_32 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  18 happyReduction_33
happyReduction_33 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn18
		 (Javalette.Abs.LIdent happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happyReduce 4 18 happyReduction_34
happyReduction_34 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (Javalette.Abs.LIndex happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_35 = happySpecReduce_3  19 happyReduction_35
happyReduction_35 _
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Javalette.Abs.Array happy_var_1
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 _
	 =  HappyAbsSyn19
		 (Javalette.Abs.Int
	)

happyReduce_37 = happySpecReduce_1  19 happyReduction_37
happyReduction_37 _
	 =  HappyAbsSyn19
		 (Javalette.Abs.Doub
	)

happyReduce_38 = happySpecReduce_1  19 happyReduction_38
happyReduction_38 _
	 =  HappyAbsSyn19
		 (Javalette.Abs.Bool
	)

happyReduce_39 = happySpecReduce_1  19 happyReduction_39
happyReduction_39 _
	 =  HappyAbsSyn19
		 (Javalette.Abs.Void
	)

happyReduce_40 = happySpecReduce_0  20 happyReduction_40
happyReduction_40  =  HappyAbsSyn20
		 ([]
	)

happyReduce_41 = happySpecReduce_1  20 happyReduction_41
happyReduction_41 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn20
		 ((:[]) happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  20 happyReduction_42
happyReduction_42 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn20
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happyReduce 5 21 happyReduction_43
happyReduction_43 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (Javalette.Abs.ENew happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happyReduce 4 22 happyReduction_45
happyReduction_45 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (Javalette.Abs.EIndex happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_46 = happySpecReduce_3  22 happyReduction_46
happyReduction_46 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.ESelect happy_var_1 happy_var_3
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  22 happyReduction_47
happyReduction_47 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.EVar happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  22 happyReduction_48
happyReduction_48 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.ELitInt happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  22 happyReduction_49
happyReduction_49 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.ELitDoub happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  22 happyReduction_50
happyReduction_50 _
	 =  HappyAbsSyn21
		 (Javalette.Abs.ELitTrue
	)

happyReduce_51 = happySpecReduce_1  22 happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn21
		 (Javalette.Abs.ELitFalse
	)

happyReduce_52 = happyReduce 4 22 happyReduction_52
happyReduction_52 (_ `HappyStk`
	(HappyAbsSyn31  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (Javalette.Abs.EApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_53 = happySpecReduce_1  22 happyReduction_53
happyReduction_53 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.EString happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  22 happyReduction_54
happyReduction_54 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_2  23 happyReduction_55
happyReduction_55 (HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (Javalette.Abs.Neg happy_var_2
	)
happyReduction_55 _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_2  23 happyReduction_56
happyReduction_56 (HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (Javalette.Abs.Not happy_var_2
	)
happyReduction_56 _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_1  23 happyReduction_57
happyReduction_57 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  24 happyReduction_58
happyReduction_58 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn33  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.EMul happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  24 happyReduction_59
happyReduction_59 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  25 happyReduction_60
happyReduction_60 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.EAdd happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  25 happyReduction_61
happyReduction_61 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  26 happyReduction_62
happyReduction_62 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn34  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.ERel happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_1  26 happyReduction_63
happyReduction_63 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  27 happyReduction_64
happyReduction_64 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.EAnd happy_var_1 happy_var_3
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_1  27 happyReduction_65
happyReduction_65 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_65 _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_3  28 happyReduction_66
happyReduction_66 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Javalette.Abs.EOr happy_var_1 happy_var_3
	)
happyReduction_66 _ _ _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_1  28 happyReduction_67
happyReduction_67 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  29 happyReduction_68
happyReduction_68 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_3  30 happyReduction_69
happyReduction_69 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (happy_var_2
	)
happyReduction_69 _ _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_0  31 happyReduction_70
happyReduction_70  =  HappyAbsSyn31
		 ([]
	)

happyReduce_71 = happySpecReduce_1  31 happyReduction_71
happyReduction_71 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn31
		 ((:[]) happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  31 happyReduction_72
happyReduction_72 (HappyAbsSyn31  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn31
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  32 happyReduction_73
happyReduction_73 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.Plus
	)

happyReduce_74 = happySpecReduce_1  32 happyReduction_74
happyReduction_74 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.Minus
	)

happyReduce_75 = happySpecReduce_1  33 happyReduction_75
happyReduction_75 _
	 =  HappyAbsSyn33
		 (Javalette.Abs.Times
	)

happyReduce_76 = happySpecReduce_1  33 happyReduction_76
happyReduction_76 _
	 =  HappyAbsSyn33
		 (Javalette.Abs.Div
	)

happyReduce_77 = happySpecReduce_1  33 happyReduction_77
happyReduction_77 _
	 =  HappyAbsSyn33
		 (Javalette.Abs.Mod
	)

happyReduce_78 = happySpecReduce_1  34 happyReduction_78
happyReduction_78 _
	 =  HappyAbsSyn34
		 (Javalette.Abs.LTH
	)

happyReduce_79 = happySpecReduce_1  34 happyReduction_79
happyReduction_79 _
	 =  HappyAbsSyn34
		 (Javalette.Abs.LE
	)

happyReduce_80 = happySpecReduce_1  34 happyReduction_80
happyReduction_80 _
	 =  HappyAbsSyn34
		 (Javalette.Abs.GTH
	)

happyReduce_81 = happySpecReduce_1  34 happyReduction_81
happyReduction_81 _
	 =  HappyAbsSyn34
		 (Javalette.Abs.GE
	)

happyReduce_82 = happySpecReduce_1  34 happyReduction_82
happyReduction_82 _
	 =  HappyAbsSyn34
		 (Javalette.Abs.EQU
	)

happyReduce_83 = happySpecReduce_1  34 happyReduction_83
happyReduction_83 _
	 =  HappyAbsSyn34
		 (Javalette.Abs.NE
	)

happyNewToken action sts stk [] =
	action 78 78 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 35;
	PT _ (TS _ 2) -> cont 36;
	PT _ (TS _ 3) -> cont 37;
	PT _ (TS _ 4) -> cont 38;
	PT _ (TS _ 5) -> cont 39;
	PT _ (TS _ 6) -> cont 40;
	PT _ (TS _ 7) -> cont 41;
	PT _ (TS _ 8) -> cont 42;
	PT _ (TS _ 9) -> cont 43;
	PT _ (TS _ 10) -> cont 44;
	PT _ (TS _ 11) -> cont 45;
	PT _ (TS _ 12) -> cont 46;
	PT _ (TS _ 13) -> cont 47;
	PT _ (TS _ 14) -> cont 48;
	PT _ (TS _ 15) -> cont 49;
	PT _ (TS _ 16) -> cont 50;
	PT _ (TS _ 17) -> cont 51;
	PT _ (TS _ 18) -> cont 52;
	PT _ (TS _ 19) -> cont 53;
	PT _ (TS _ 20) -> cont 54;
	PT _ (TS _ 21) -> cont 55;
	PT _ (TS _ 22) -> cont 56;
	PT _ (TS _ 23) -> cont 57;
	PT _ (TS _ 24) -> cont 58;
	PT _ (TS _ 25) -> cont 59;
	PT _ (TS _ 26) -> cont 60;
	PT _ (TS _ 27) -> cont 61;
	PT _ (TS _ 28) -> cont 62;
	PT _ (TS _ 29) -> cont 63;
	PT _ (TS _ 30) -> cont 64;
	PT _ (TS _ 31) -> cont 65;
	PT _ (TS _ 32) -> cont 66;
	PT _ (TS _ 33) -> cont 67;
	PT _ (TS _ 34) -> cont 68;
	PT _ (TS _ 35) -> cont 69;
	PT _ (TS _ 36) -> cont 70;
	PT _ (TS _ 37) -> cont 71;
	PT _ (TS _ 38) -> cont 72;
	PT _ (TS _ 39) -> cont 73;
	PT _ (TV happy_dollar_dollar) -> cont 74;
	PT _ (TD happy_dollar_dollar) -> cont 75;
	PT _ (TI happy_dollar_dollar) -> cont 76;
	PT _ (TL happy_dollar_dollar) -> cont 77;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 78 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = ((>>=))
happyReturn :: () => a -> Err a
happyReturn = (return)
happyThen1 m k tks = ((>>=)) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> Err a
happyError' = (\(tokens, _) -> happyError tokens)
pProg tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn8 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


type Err = Either String

happyError :: [Token] -> Err a
happyError ts = Left $
  "syntax error at " ++ tokenPos ts ++
  case ts of
    []      -> []
    [Err _] -> " due to lexer error"
    t:_     -> " before `" ++ (prToken t) ++ "'"

myLexer :: String -> [Token]
myLexer = tokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
