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
	| HappyAbsSyn18 (Javalette.Abs.Type)
	| HappyAbsSyn19 ([Javalette.Abs.Type])
	| HappyAbsSyn20 (Javalette.Abs.Expr)
	| HappyAbsSyn29 ([Javalette.Abs.Expr])
	| HappyAbsSyn30 (Javalette.Abs.AddOp)
	| HappyAbsSyn31 (Javalette.Abs.MulOp)
	| HappyAbsSyn32 (Javalette.Abs.RelOp)

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
 happyReduce_81 :: () => ({-HappyReduction (Err) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,537) ([0,0,0,4480,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,8472,0,0,0,0,0,0,0,0,128,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,12288,66,0,0,512,0,0,0,0,1,0,0,0,0,2048,4096,0,0,0,0,0,0,0,0,32768,0,0,0,49152,264,0,0,0,0,0,0,0,0,0,0,0,4352,32836,53213,3,0,51328,272,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,33312,45064,31227,0,0,0,32,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,516,0,0,0,16384,2,0,0,0,40,118,0,0,0,0,0,2,0,0,64,0,0,0,0,0,0,0,0,4,4096,16,0,8704,8,33416,7,0,256,0,1028,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,4480,2,0,34816,544,2592,30,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,130,10368,120,0,4096,8208,0,0,0,0,2,0,0,0,0,0,0,0,0,16384,0,0,0,16656,16384,15380,0,0,0,16,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,1088,1,61521,0,0,2082,34816,1922,0,0,0,0,0,0,2176,2,57506,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8704,8,33416,7,0,0,0,0,0,0,0,0,0,0,17408,16,1296,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2176,0,0,0,1024,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,8192,130,10368,120,0,0,64,0,0,0,0,2,0,0,0,0,2048,0,0,8704,8,33416,7,0,16656,16384,15380,0,0,0,0,0,0,0,0,1,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,256,0,8192,130,10368,120,0,0,16384,0,0,0,0,0,0,0,0,2065,0,0,0,0,0,0,0,0,18432,0,0,0,0,0,0,0,0,0,0,0,0,0,512,32768,30760,0,0,32,0,0,0,32768,0,2594,30,0,0,0,0,0,0,64,0,0,0,4096,1089,64984,60,0,0,8192,0,0,0,4164,30209,3903,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16656,16384,15380,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,1041,17408,961,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2176,49186,59374,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProg","Ident","Double","Integer","String","Prog","TopDef","ListTopDef","Arg","ListArg","Blk","ListStmt","Stmt","Item","ListItem","Type","ListType","Expr7","Expr6","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","Expr8","ListExpr","AddOp","MulOp","RelOp","'!'","'!='","'%'","'&&'","'('","')'","'*'","'+'","'++'","','","'-'","'--'","'.'","'/'","';'","'<'","'<='","'='","'=='","'>'","'>='","'['","']'","'boolean'","'double'","'else'","'false'","'if'","'int'","'length'","'new'","'return'","'true'","'void'","'while'","'{'","'||'","'}'","L_Ident","L_doubl","L_integ","L_quoted","%eof"]
        bit_start = st Prelude.* 75
        bit_end = (st Prelude.+ 1) Prelude.* 75
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..74]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (56) = happyShift action_7
action_0 (57) = happyShift action_8
action_0 (61) = happyShift action_9
action_0 (66) = happyShift action_10
action_0 (8) = happyGoto action_3
action_0 (9) = happyGoto action_4
action_0 (10) = happyGoto action_5
action_0 (18) = happyGoto action_6
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (71) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (75) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (56) = happyShift action_7
action_4 (57) = happyShift action_8
action_4 (61) = happyShift action_9
action_4 (66) = happyShift action_10
action_4 (9) = happyGoto action_4
action_4 (10) = happyGoto action_13
action_4 (18) = happyGoto action_6
action_4 _ = happyReduce_7

action_5 _ = happyReduce_5

action_6 (54) = happyShift action_12
action_6 (71) = happyShift action_2
action_6 (4) = happyGoto action_11
action_6 _ = happyFail (happyExpListPerState 6)

action_7 _ = happyReduce_37

action_8 _ = happyReduce_36

action_9 _ = happyReduce_35

action_10 _ = happyReduce_38

action_11 (37) = happyShift action_15
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (55) = happyShift action_14
action_12 _ = happyFail (happyExpListPerState 12)

action_13 _ = happyReduce_8

action_14 _ = happyReduce_34

action_15 (56) = happyShift action_7
action_15 (57) = happyShift action_8
action_15 (61) = happyShift action_9
action_15 (66) = happyShift action_10
action_15 (11) = happyGoto action_16
action_15 (12) = happyGoto action_17
action_15 (18) = happyGoto action_18
action_15 _ = happyReduce_10

action_16 (42) = happyShift action_21
action_16 _ = happyReduce_11

action_17 (38) = happyShift action_20
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (54) = happyShift action_12
action_18 (71) = happyShift action_2
action_18 (4) = happyGoto action_19
action_18 _ = happyFail (happyExpListPerState 18)

action_19 _ = happyReduce_9

action_20 (68) = happyShift action_24
action_20 (13) = happyGoto action_23
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (56) = happyShift action_7
action_21 (57) = happyShift action_8
action_21 (61) = happyShift action_9
action_21 (66) = happyShift action_10
action_21 (11) = happyGoto action_16
action_21 (12) = happyGoto action_22
action_21 (18) = happyGoto action_18
action_21 _ = happyReduce_10

action_22 _ = happyReduce_12

action_23 _ = happyReduce_6

action_24 (33) = happyShift action_42
action_24 (37) = happyShift action_43
action_24 (43) = happyShift action_44
action_24 (47) = happyShift action_45
action_24 (56) = happyShift action_7
action_24 (57) = happyShift action_8
action_24 (59) = happyShift action_46
action_24 (60) = happyShift action_47
action_24 (61) = happyShift action_9
action_24 (63) = happyShift action_48
action_24 (64) = happyShift action_49
action_24 (65) = happyShift action_50
action_24 (66) = happyShift action_10
action_24 (67) = happyShift action_51
action_24 (68) = happyShift action_24
action_24 (71) = happyShift action_2
action_24 (72) = happyShift action_52
action_24 (73) = happyShift action_53
action_24 (74) = happyShift action_54
action_24 (4) = happyGoto action_25
action_24 (5) = happyGoto action_26
action_24 (6) = happyGoto action_27
action_24 (7) = happyGoto action_28
action_24 (13) = happyGoto action_29
action_24 (14) = happyGoto action_30
action_24 (15) = happyGoto action_31
action_24 (18) = happyGoto action_32
action_24 (20) = happyGoto action_33
action_24 (21) = happyGoto action_34
action_24 (22) = happyGoto action_35
action_24 (23) = happyGoto action_36
action_24 (24) = happyGoto action_37
action_24 (25) = happyGoto action_38
action_24 (26) = happyGoto action_39
action_24 (27) = happyGoto action_40
action_24 (28) = happyGoto action_41
action_24 _ = happyReduce_14

action_25 (37) = happyShift action_87
action_25 (41) = happyShift action_88
action_25 (44) = happyShift action_89
action_25 (45) = happyShift action_90
action_25 (50) = happyShift action_91
action_25 (54) = happyShift action_92
action_25 _ = happyReduce_46

action_26 _ = happyReduce_48

action_27 _ = happyReduce_47

action_28 _ = happyReduce_52

action_29 _ = happyReduce_17

action_30 (70) = happyShift action_86
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (33) = happyShift action_42
action_31 (37) = happyShift action_43
action_31 (43) = happyShift action_44
action_31 (47) = happyShift action_45
action_31 (56) = happyShift action_7
action_31 (57) = happyShift action_8
action_31 (59) = happyShift action_46
action_31 (60) = happyShift action_47
action_31 (61) = happyShift action_9
action_31 (63) = happyShift action_48
action_31 (64) = happyShift action_49
action_31 (65) = happyShift action_50
action_31 (66) = happyShift action_10
action_31 (67) = happyShift action_51
action_31 (68) = happyShift action_24
action_31 (71) = happyShift action_2
action_31 (72) = happyShift action_52
action_31 (73) = happyShift action_53
action_31 (74) = happyShift action_54
action_31 (4) = happyGoto action_25
action_31 (5) = happyGoto action_26
action_31 (6) = happyGoto action_27
action_31 (7) = happyGoto action_28
action_31 (13) = happyGoto action_29
action_31 (14) = happyGoto action_85
action_31 (15) = happyGoto action_31
action_31 (18) = happyGoto action_32
action_31 (20) = happyGoto action_33
action_31 (21) = happyGoto action_34
action_31 (22) = happyGoto action_35
action_31 (23) = happyGoto action_36
action_31 (24) = happyGoto action_37
action_31 (25) = happyGoto action_38
action_31 (26) = happyGoto action_39
action_31 (27) = happyGoto action_40
action_31 (28) = happyGoto action_41
action_31 _ = happyReduce_14

action_32 (54) = happyShift action_12
action_32 (71) = happyShift action_2
action_32 (4) = happyGoto action_82
action_32 (16) = happyGoto action_83
action_32 (17) = happyGoto action_84
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_53

action_34 _ = happyReduce_56

action_35 _ = happyReduce_58

action_36 (35) = happyShift action_79
action_36 (39) = happyShift action_80
action_36 (46) = happyShift action_81
action_36 (31) = happyGoto action_78
action_36 _ = happyReduce_60

action_37 (40) = happyShift action_76
action_37 (43) = happyShift action_77
action_37 (30) = happyGoto action_75
action_37 _ = happyReduce_62

action_38 (34) = happyShift action_68
action_38 (36) = happyShift action_69
action_38 (48) = happyShift action_70
action_38 (49) = happyShift action_71
action_38 (51) = happyShift action_72
action_38 (52) = happyShift action_73
action_38 (53) = happyShift action_74
action_38 (32) = happyGoto action_67
action_38 _ = happyReduce_64

action_39 (69) = happyShift action_66
action_39 _ = happyReduce_66

action_40 (47) = happyShift action_65
action_40 _ = happyFail (happyExpListPerState 40)

action_41 _ = happyReduce_44

action_42 (37) = happyShift action_43
action_42 (63) = happyShift action_48
action_42 (71) = happyShift action_2
action_42 (4) = happyGoto action_61
action_42 (20) = happyGoto action_64
action_42 (28) = happyGoto action_41
action_42 _ = happyFail (happyExpListPerState 42)

action_43 (33) = happyShift action_42
action_43 (37) = happyShift action_43
action_43 (43) = happyShift action_44
action_43 (59) = happyShift action_46
action_43 (63) = happyShift action_48
action_43 (65) = happyShift action_50
action_43 (71) = happyShift action_2
action_43 (72) = happyShift action_52
action_43 (73) = happyShift action_53
action_43 (74) = happyShift action_54
action_43 (4) = happyGoto action_56
action_43 (5) = happyGoto action_26
action_43 (6) = happyGoto action_27
action_43 (7) = happyGoto action_28
action_43 (20) = happyGoto action_33
action_43 (21) = happyGoto action_34
action_43 (22) = happyGoto action_35
action_43 (23) = happyGoto action_36
action_43 (24) = happyGoto action_37
action_43 (25) = happyGoto action_38
action_43 (26) = happyGoto action_39
action_43 (27) = happyGoto action_63
action_43 (28) = happyGoto action_41
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (37) = happyShift action_43
action_44 (63) = happyShift action_48
action_44 (71) = happyShift action_2
action_44 (4) = happyGoto action_61
action_44 (20) = happyGoto action_62
action_44 (28) = happyGoto action_41
action_44 _ = happyFail (happyExpListPerState 44)

action_45 _ = happyReduce_16

action_46 _ = happyReduce_50

action_47 (37) = happyShift action_60
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (56) = happyShift action_7
action_48 (57) = happyShift action_8
action_48 (61) = happyShift action_9
action_48 (66) = happyShift action_10
action_48 (18) = happyGoto action_59
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (33) = happyShift action_42
action_49 (37) = happyShift action_43
action_49 (43) = happyShift action_44
action_49 (47) = happyShift action_58
action_49 (59) = happyShift action_46
action_49 (63) = happyShift action_48
action_49 (65) = happyShift action_50
action_49 (71) = happyShift action_2
action_49 (72) = happyShift action_52
action_49 (73) = happyShift action_53
action_49 (74) = happyShift action_54
action_49 (4) = happyGoto action_56
action_49 (5) = happyGoto action_26
action_49 (6) = happyGoto action_27
action_49 (7) = happyGoto action_28
action_49 (20) = happyGoto action_33
action_49 (21) = happyGoto action_34
action_49 (22) = happyGoto action_35
action_49 (23) = happyGoto action_36
action_49 (24) = happyGoto action_37
action_49 (25) = happyGoto action_38
action_49 (26) = happyGoto action_39
action_49 (27) = happyGoto action_57
action_49 (28) = happyGoto action_41
action_49 _ = happyFail (happyExpListPerState 49)

action_50 _ = happyReduce_49

action_51 (37) = happyShift action_55
action_51 _ = happyFail (happyExpListPerState 51)

action_52 _ = happyReduce_2

action_53 _ = happyReduce_3

action_54 _ = happyReduce_4

action_55 (33) = happyShift action_42
action_55 (37) = happyShift action_43
action_55 (43) = happyShift action_44
action_55 (59) = happyShift action_46
action_55 (63) = happyShift action_48
action_55 (65) = happyShift action_50
action_55 (71) = happyShift action_2
action_55 (72) = happyShift action_52
action_55 (73) = happyShift action_53
action_55 (74) = happyShift action_54
action_55 (4) = happyGoto action_56
action_55 (5) = happyGoto action_26
action_55 (6) = happyGoto action_27
action_55 (7) = happyGoto action_28
action_55 (20) = happyGoto action_33
action_55 (21) = happyGoto action_34
action_55 (22) = happyGoto action_35
action_55 (23) = happyGoto action_36
action_55 (24) = happyGoto action_37
action_55 (25) = happyGoto action_38
action_55 (26) = happyGoto action_39
action_55 (27) = happyGoto action_115
action_55 (28) = happyGoto action_41
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (37) = happyShift action_87
action_56 (45) = happyShift action_90
action_56 (54) = happyShift action_111
action_56 _ = happyReduce_46

action_57 (47) = happyShift action_114
action_57 _ = happyFail (happyExpListPerState 57)

action_58 _ = happyReduce_24

action_59 (54) = happyShift action_113
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (33) = happyShift action_42
action_60 (37) = happyShift action_43
action_60 (43) = happyShift action_44
action_60 (59) = happyShift action_46
action_60 (63) = happyShift action_48
action_60 (65) = happyShift action_50
action_60 (71) = happyShift action_2
action_60 (72) = happyShift action_52
action_60 (73) = happyShift action_53
action_60 (74) = happyShift action_54
action_60 (4) = happyGoto action_56
action_60 (5) = happyGoto action_26
action_60 (6) = happyGoto action_27
action_60 (7) = happyGoto action_28
action_60 (20) = happyGoto action_33
action_60 (21) = happyGoto action_34
action_60 (22) = happyGoto action_35
action_60 (23) = happyGoto action_36
action_60 (24) = happyGoto action_37
action_60 (25) = happyGoto action_38
action_60 (26) = happyGoto action_39
action_60 (27) = happyGoto action_112
action_60 (28) = happyGoto action_41
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (54) = happyShift action_111
action_61 _ = happyFail (happyExpListPerState 61)

action_62 _ = happyReduce_54

action_63 (38) = happyShift action_110
action_63 _ = happyFail (happyExpListPerState 63)

action_64 _ = happyReduce_55

action_65 _ = happyReduce_28

action_66 (33) = happyShift action_42
action_66 (37) = happyShift action_43
action_66 (43) = happyShift action_44
action_66 (59) = happyShift action_46
action_66 (63) = happyShift action_48
action_66 (65) = happyShift action_50
action_66 (71) = happyShift action_2
action_66 (72) = happyShift action_52
action_66 (73) = happyShift action_53
action_66 (74) = happyShift action_54
action_66 (4) = happyGoto action_56
action_66 (5) = happyGoto action_26
action_66 (6) = happyGoto action_27
action_66 (7) = happyGoto action_28
action_66 (20) = happyGoto action_33
action_66 (21) = happyGoto action_34
action_66 (22) = happyGoto action_35
action_66 (23) = happyGoto action_36
action_66 (24) = happyGoto action_37
action_66 (25) = happyGoto action_38
action_66 (26) = happyGoto action_39
action_66 (27) = happyGoto action_109
action_66 (28) = happyGoto action_41
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (33) = happyShift action_42
action_67 (37) = happyShift action_43
action_67 (43) = happyShift action_44
action_67 (59) = happyShift action_46
action_67 (63) = happyShift action_48
action_67 (65) = happyShift action_50
action_67 (71) = happyShift action_2
action_67 (72) = happyShift action_52
action_67 (73) = happyShift action_53
action_67 (74) = happyShift action_54
action_67 (4) = happyGoto action_56
action_67 (5) = happyGoto action_26
action_67 (6) = happyGoto action_27
action_67 (7) = happyGoto action_28
action_67 (20) = happyGoto action_33
action_67 (21) = happyGoto action_34
action_67 (22) = happyGoto action_35
action_67 (23) = happyGoto action_36
action_67 (24) = happyGoto action_108
action_67 (28) = happyGoto action_41
action_67 _ = happyFail (happyExpListPerState 67)

action_68 _ = happyReduce_81

action_69 (33) = happyShift action_42
action_69 (37) = happyShift action_43
action_69 (43) = happyShift action_44
action_69 (59) = happyShift action_46
action_69 (63) = happyShift action_48
action_69 (65) = happyShift action_50
action_69 (71) = happyShift action_2
action_69 (72) = happyShift action_52
action_69 (73) = happyShift action_53
action_69 (74) = happyShift action_54
action_69 (4) = happyGoto action_56
action_69 (5) = happyGoto action_26
action_69 (6) = happyGoto action_27
action_69 (7) = happyGoto action_28
action_69 (20) = happyGoto action_33
action_69 (21) = happyGoto action_34
action_69 (22) = happyGoto action_35
action_69 (23) = happyGoto action_36
action_69 (24) = happyGoto action_37
action_69 (25) = happyGoto action_38
action_69 (26) = happyGoto action_107
action_69 (28) = happyGoto action_41
action_69 _ = happyFail (happyExpListPerState 69)

action_70 _ = happyReduce_76

action_71 _ = happyReduce_77

action_72 _ = happyReduce_80

action_73 _ = happyReduce_78

action_74 _ = happyReduce_79

action_75 (33) = happyShift action_42
action_75 (37) = happyShift action_43
action_75 (43) = happyShift action_44
action_75 (59) = happyShift action_46
action_75 (63) = happyShift action_48
action_75 (65) = happyShift action_50
action_75 (71) = happyShift action_2
action_75 (72) = happyShift action_52
action_75 (73) = happyShift action_53
action_75 (74) = happyShift action_54
action_75 (4) = happyGoto action_56
action_75 (5) = happyGoto action_26
action_75 (6) = happyGoto action_27
action_75 (7) = happyGoto action_28
action_75 (20) = happyGoto action_33
action_75 (21) = happyGoto action_34
action_75 (22) = happyGoto action_35
action_75 (23) = happyGoto action_106
action_75 (28) = happyGoto action_41
action_75 _ = happyFail (happyExpListPerState 75)

action_76 _ = happyReduce_71

action_77 _ = happyReduce_72

action_78 (33) = happyShift action_42
action_78 (37) = happyShift action_43
action_78 (43) = happyShift action_44
action_78 (59) = happyShift action_46
action_78 (63) = happyShift action_48
action_78 (65) = happyShift action_50
action_78 (71) = happyShift action_2
action_78 (72) = happyShift action_52
action_78 (73) = happyShift action_53
action_78 (74) = happyShift action_54
action_78 (4) = happyGoto action_56
action_78 (5) = happyGoto action_26
action_78 (6) = happyGoto action_27
action_78 (7) = happyGoto action_28
action_78 (20) = happyGoto action_33
action_78 (21) = happyGoto action_34
action_78 (22) = happyGoto action_105
action_78 (28) = happyGoto action_41
action_78 _ = happyFail (happyExpListPerState 78)

action_79 _ = happyReduce_75

action_80 _ = happyReduce_73

action_81 _ = happyReduce_74

action_82 (50) = happyShift action_103
action_82 (54) = happyShift action_104
action_82 _ = happyReduce_29

action_83 (42) = happyShift action_102
action_83 _ = happyReduce_32

action_84 (47) = happyShift action_101
action_84 _ = happyFail (happyExpListPerState 84)

action_85 _ = happyReduce_15

action_86 _ = happyReduce_13

action_87 (33) = happyShift action_42
action_87 (37) = happyShift action_43
action_87 (43) = happyShift action_44
action_87 (59) = happyShift action_46
action_87 (63) = happyShift action_48
action_87 (65) = happyShift action_50
action_87 (71) = happyShift action_2
action_87 (72) = happyShift action_52
action_87 (73) = happyShift action_53
action_87 (74) = happyShift action_54
action_87 (4) = happyGoto action_56
action_87 (5) = happyGoto action_26
action_87 (6) = happyGoto action_27
action_87 (7) = happyGoto action_28
action_87 (20) = happyGoto action_33
action_87 (21) = happyGoto action_34
action_87 (22) = happyGoto action_35
action_87 (23) = happyGoto action_36
action_87 (24) = happyGoto action_37
action_87 (25) = happyGoto action_38
action_87 (26) = happyGoto action_39
action_87 (27) = happyGoto action_99
action_87 (28) = happyGoto action_41
action_87 (29) = happyGoto action_100
action_87 _ = happyReduce_68

action_88 (47) = happyShift action_98
action_88 _ = happyFail (happyExpListPerState 88)

action_89 (47) = happyShift action_97
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (62) = happyShift action_96
action_90 _ = happyFail (happyExpListPerState 90)

action_91 (33) = happyShift action_42
action_91 (37) = happyShift action_43
action_91 (43) = happyShift action_44
action_91 (59) = happyShift action_46
action_91 (63) = happyShift action_48
action_91 (65) = happyShift action_50
action_91 (71) = happyShift action_2
action_91 (72) = happyShift action_52
action_91 (73) = happyShift action_53
action_91 (74) = happyShift action_54
action_91 (4) = happyGoto action_56
action_91 (5) = happyGoto action_26
action_91 (6) = happyGoto action_27
action_91 (7) = happyGoto action_28
action_91 (20) = happyGoto action_33
action_91 (21) = happyGoto action_34
action_91 (22) = happyGoto action_35
action_91 (23) = happyGoto action_36
action_91 (24) = happyGoto action_37
action_91 (25) = happyGoto action_38
action_91 (26) = happyGoto action_39
action_91 (27) = happyGoto action_95
action_91 (28) = happyGoto action_41
action_91 _ = happyFail (happyExpListPerState 91)

action_92 (33) = happyShift action_42
action_92 (37) = happyShift action_43
action_92 (43) = happyShift action_44
action_92 (59) = happyShift action_46
action_92 (63) = happyShift action_48
action_92 (65) = happyShift action_50
action_92 (71) = happyShift action_2
action_92 (72) = happyShift action_52
action_92 (73) = happyShift action_53
action_92 (74) = happyShift action_54
action_92 (4) = happyGoto action_56
action_92 (5) = happyGoto action_26
action_92 (6) = happyGoto action_27
action_92 (7) = happyGoto action_28
action_92 (20) = happyGoto action_33
action_92 (21) = happyGoto action_93
action_92 (22) = happyGoto action_35
action_92 (23) = happyGoto action_36
action_92 (24) = happyGoto action_37
action_92 (25) = happyGoto action_38
action_92 (26) = happyGoto action_39
action_92 (27) = happyGoto action_94
action_92 (28) = happyGoto action_41
action_92 _ = happyFail (happyExpListPerState 92)

action_93 (55) = happyShift action_127
action_93 _ = happyReduce_56

action_94 (55) = happyShift action_126
action_94 _ = happyFail (happyExpListPerState 94)

action_95 (47) = happyShift action_125
action_95 _ = happyFail (happyExpListPerState 95)

action_96 _ = happyReduce_45

action_97 _ = happyReduce_22

action_98 _ = happyReduce_21

action_99 (42) = happyShift action_124
action_99 _ = happyReduce_69

action_100 (38) = happyShift action_123
action_100 _ = happyFail (happyExpListPerState 100)

action_101 _ = happyReduce_18

action_102 (71) = happyShift action_2
action_102 (4) = happyGoto action_82
action_102 (16) = happyGoto action_83
action_102 (17) = happyGoto action_122
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (33) = happyShift action_42
action_103 (37) = happyShift action_43
action_103 (43) = happyShift action_44
action_103 (59) = happyShift action_46
action_103 (63) = happyShift action_48
action_103 (65) = happyShift action_50
action_103 (71) = happyShift action_2
action_103 (72) = happyShift action_52
action_103 (73) = happyShift action_53
action_103 (74) = happyShift action_54
action_103 (4) = happyGoto action_56
action_103 (5) = happyGoto action_26
action_103 (6) = happyGoto action_27
action_103 (7) = happyGoto action_28
action_103 (20) = happyGoto action_33
action_103 (21) = happyGoto action_34
action_103 (22) = happyGoto action_35
action_103 (23) = happyGoto action_36
action_103 (24) = happyGoto action_37
action_103 (25) = happyGoto action_38
action_103 (26) = happyGoto action_39
action_103 (27) = happyGoto action_121
action_103 (28) = happyGoto action_41
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (55) = happyShift action_120
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_57

action_106 (35) = happyShift action_79
action_106 (39) = happyShift action_80
action_106 (46) = happyShift action_81
action_106 (31) = happyGoto action_78
action_106 _ = happyReduce_59

action_107 _ = happyReduce_63

action_108 (40) = happyShift action_76
action_108 (43) = happyShift action_77
action_108 (30) = happyGoto action_75
action_108 _ = happyReduce_61

action_109 _ = happyReduce_65

action_110 _ = happyReduce_67

action_111 (37) = happyShift action_43
action_111 (59) = happyShift action_46
action_111 (63) = happyShift action_48
action_111 (65) = happyShift action_50
action_111 (71) = happyShift action_2
action_111 (72) = happyShift action_52
action_111 (73) = happyShift action_53
action_111 (74) = happyShift action_54
action_111 (4) = happyGoto action_56
action_111 (5) = happyGoto action_26
action_111 (6) = happyGoto action_27
action_111 (7) = happyGoto action_28
action_111 (20) = happyGoto action_33
action_111 (21) = happyGoto action_119
action_111 (28) = happyGoto action_41
action_111 _ = happyFail (happyExpListPerState 111)

action_112 (38) = happyShift action_118
action_112 _ = happyFail (happyExpListPerState 112)

action_113 (37) = happyShift action_43
action_113 (55) = happyShift action_14
action_113 (59) = happyShift action_46
action_113 (63) = happyShift action_48
action_113 (65) = happyShift action_50
action_113 (71) = happyShift action_2
action_113 (72) = happyShift action_52
action_113 (73) = happyShift action_53
action_113 (74) = happyShift action_54
action_113 (4) = happyGoto action_56
action_113 (5) = happyGoto action_26
action_113 (6) = happyGoto action_27
action_113 (7) = happyGoto action_28
action_113 (20) = happyGoto action_33
action_113 (21) = happyGoto action_117
action_113 (28) = happyGoto action_41
action_113 _ = happyFail (happyExpListPerState 113)

action_114 _ = happyReduce_23

action_115 (38) = happyShift action_116
action_115 _ = happyFail (happyExpListPerState 115)

action_116 (33) = happyShift action_42
action_116 (37) = happyShift action_43
action_116 (43) = happyShift action_44
action_116 (47) = happyShift action_45
action_116 (56) = happyShift action_7
action_116 (57) = happyShift action_8
action_116 (59) = happyShift action_46
action_116 (60) = happyShift action_47
action_116 (61) = happyShift action_9
action_116 (63) = happyShift action_48
action_116 (64) = happyShift action_49
action_116 (65) = happyShift action_50
action_116 (66) = happyShift action_10
action_116 (67) = happyShift action_51
action_116 (68) = happyShift action_24
action_116 (71) = happyShift action_2
action_116 (72) = happyShift action_52
action_116 (73) = happyShift action_53
action_116 (74) = happyShift action_54
action_116 (4) = happyGoto action_25
action_116 (5) = happyGoto action_26
action_116 (6) = happyGoto action_27
action_116 (7) = happyGoto action_28
action_116 (13) = happyGoto action_29
action_116 (15) = happyGoto action_132
action_116 (18) = happyGoto action_32
action_116 (20) = happyGoto action_33
action_116 (21) = happyGoto action_34
action_116 (22) = happyGoto action_35
action_116 (23) = happyGoto action_36
action_116 (24) = happyGoto action_37
action_116 (25) = happyGoto action_38
action_116 (26) = happyGoto action_39
action_116 (27) = happyGoto action_40
action_116 (28) = happyGoto action_41
action_116 _ = happyFail (happyExpListPerState 116)

action_117 (55) = happyShift action_131
action_117 _ = happyFail (happyExpListPerState 117)

action_118 (33) = happyShift action_42
action_118 (37) = happyShift action_43
action_118 (43) = happyShift action_44
action_118 (47) = happyShift action_45
action_118 (56) = happyShift action_7
action_118 (57) = happyShift action_8
action_118 (59) = happyShift action_46
action_118 (60) = happyShift action_47
action_118 (61) = happyShift action_9
action_118 (63) = happyShift action_48
action_118 (64) = happyShift action_49
action_118 (65) = happyShift action_50
action_118 (66) = happyShift action_10
action_118 (67) = happyShift action_51
action_118 (68) = happyShift action_24
action_118 (71) = happyShift action_2
action_118 (72) = happyShift action_52
action_118 (73) = happyShift action_53
action_118 (74) = happyShift action_54
action_118 (4) = happyGoto action_25
action_118 (5) = happyGoto action_26
action_118 (6) = happyGoto action_27
action_118 (7) = happyGoto action_28
action_118 (13) = happyGoto action_29
action_118 (15) = happyGoto action_130
action_118 (18) = happyGoto action_32
action_118 (20) = happyGoto action_33
action_118 (21) = happyGoto action_34
action_118 (22) = happyGoto action_35
action_118 (23) = happyGoto action_36
action_118 (24) = happyGoto action_37
action_118 (25) = happyGoto action_38
action_118 (26) = happyGoto action_39
action_118 (27) = happyGoto action_40
action_118 (28) = happyGoto action_41
action_118 _ = happyFail (happyExpListPerState 118)

action_119 (55) = happyShift action_127
action_119 _ = happyFail (happyExpListPerState 119)

action_120 _ = happyReduce_30

action_121 _ = happyReduce_31

action_122 _ = happyReduce_33

action_123 _ = happyReduce_51

action_124 (33) = happyShift action_42
action_124 (37) = happyShift action_43
action_124 (43) = happyShift action_44
action_124 (59) = happyShift action_46
action_124 (63) = happyShift action_48
action_124 (65) = happyShift action_50
action_124 (71) = happyShift action_2
action_124 (72) = happyShift action_52
action_124 (73) = happyShift action_53
action_124 (74) = happyShift action_54
action_124 (4) = happyGoto action_56
action_124 (5) = happyGoto action_26
action_124 (6) = happyGoto action_27
action_124 (7) = happyGoto action_28
action_124 (20) = happyGoto action_33
action_124 (21) = happyGoto action_34
action_124 (22) = happyGoto action_35
action_124 (23) = happyGoto action_36
action_124 (24) = happyGoto action_37
action_124 (25) = happyGoto action_38
action_124 (26) = happyGoto action_39
action_124 (27) = happyGoto action_99
action_124 (28) = happyGoto action_41
action_124 (29) = happyGoto action_129
action_124 _ = happyReduce_68

action_125 _ = happyReduce_20

action_126 (50) = happyShift action_128
action_126 _ = happyFail (happyExpListPerState 126)

action_127 _ = happyReduce_43

action_128 (33) = happyShift action_42
action_128 (37) = happyShift action_43
action_128 (43) = happyShift action_44
action_128 (59) = happyShift action_46
action_128 (63) = happyShift action_48
action_128 (65) = happyShift action_50
action_128 (71) = happyShift action_2
action_128 (72) = happyShift action_52
action_128 (73) = happyShift action_53
action_128 (74) = happyShift action_54
action_128 (4) = happyGoto action_56
action_128 (5) = happyGoto action_26
action_128 (6) = happyGoto action_27
action_128 (7) = happyGoto action_28
action_128 (20) = happyGoto action_33
action_128 (21) = happyGoto action_34
action_128 (22) = happyGoto action_35
action_128 (23) = happyGoto action_36
action_128 (24) = happyGoto action_37
action_128 (25) = happyGoto action_38
action_128 (26) = happyGoto action_39
action_128 (27) = happyGoto action_134
action_128 (28) = happyGoto action_41
action_128 _ = happyFail (happyExpListPerState 128)

action_129 _ = happyReduce_70

action_130 (58) = happyShift action_133
action_130 _ = happyReduce_25

action_131 _ = happyReduce_42

action_132 _ = happyReduce_27

action_133 (33) = happyShift action_42
action_133 (37) = happyShift action_43
action_133 (43) = happyShift action_44
action_133 (47) = happyShift action_45
action_133 (56) = happyShift action_7
action_133 (57) = happyShift action_8
action_133 (59) = happyShift action_46
action_133 (60) = happyShift action_47
action_133 (61) = happyShift action_9
action_133 (63) = happyShift action_48
action_133 (64) = happyShift action_49
action_133 (65) = happyShift action_50
action_133 (66) = happyShift action_10
action_133 (67) = happyShift action_51
action_133 (68) = happyShift action_24
action_133 (71) = happyShift action_2
action_133 (72) = happyShift action_52
action_133 (73) = happyShift action_53
action_133 (74) = happyShift action_54
action_133 (4) = happyGoto action_25
action_133 (5) = happyGoto action_26
action_133 (6) = happyGoto action_27
action_133 (7) = happyGoto action_28
action_133 (13) = happyGoto action_29
action_133 (15) = happyGoto action_136
action_133 (18) = happyGoto action_32
action_133 (20) = happyGoto action_33
action_133 (21) = happyGoto action_34
action_133 (22) = happyGoto action_35
action_133 (23) = happyGoto action_36
action_133 (24) = happyGoto action_37
action_133 (25) = happyGoto action_38
action_133 (26) = happyGoto action_39
action_133 (27) = happyGoto action_40
action_133 (28) = happyGoto action_41
action_133 _ = happyFail (happyExpListPerState 133)

action_134 (47) = happyShift action_135
action_134 _ = happyFail (happyExpListPerState 134)

action_135 _ = happyReduce_19

action_136 _ = happyReduce_26

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
	(HappyAbsSyn18  happy_var_1) `HappyStk`
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
	(HappyAbsSyn18  happy_var_1)
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
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.Decl happy_var_1 happy_var_2
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happyReduce 7 15 happyReduction_19
happyReduction_19 (_ `HappyStk`
	(HappyAbsSyn20  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.IndexAss happy_var_1 happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_20 = happyReduce 4 15 happyReduction_20
happyReduction_20 (_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.Ass happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_21 = happySpecReduce_3  15 happyReduction_21
happyReduction_21 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.Incr happy_var_1
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  15 happyReduction_22
happyReduction_22 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 (Javalette.Abs.Decr happy_var_1
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  15 happyReduction_23
happyReduction_23 _
	(HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (Javalette.Abs.Ret happy_var_2
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_2  15 happyReduction_24
happyReduction_24 _
	_
	 =  HappyAbsSyn15
		 (Javalette.Abs.VRet
	)

happyReduce_25 = happyReduce 5 15 happyReduction_25
happyReduction_25 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.Cond happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_26 = happyReduce 7 15 happyReduction_26
happyReduction_26 ((HappyAbsSyn15  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.CondElse happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_27 = happyReduce 5 15 happyReduction_27
happyReduction_27 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Javalette.Abs.While happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_28 = happySpecReduce_2  15 happyReduction_28
happyReduction_28 _
	(HappyAbsSyn20  happy_var_1)
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
happyReduction_30 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn16
		 (Javalette.Abs.NoInitArr happy_var_1
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_3  16 happyReduction_31
happyReduction_31 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn16
		 (Javalette.Abs.Init happy_var_1 happy_var_3
	)
happyReduction_31 _ _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  17 happyReduction_32
happyReduction_32 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 ((:[]) happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  17 happyReduction_33
happyReduction_33 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  18 happyReduction_34
happyReduction_34 _
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (Javalette.Abs.Array happy_var_1
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  18 happyReduction_35
happyReduction_35 _
	 =  HappyAbsSyn18
		 (Javalette.Abs.Int
	)

happyReduce_36 = happySpecReduce_1  18 happyReduction_36
happyReduction_36 _
	 =  HappyAbsSyn18
		 (Javalette.Abs.Doub
	)

happyReduce_37 = happySpecReduce_1  18 happyReduction_37
happyReduction_37 _
	 =  HappyAbsSyn18
		 (Javalette.Abs.Bool
	)

happyReduce_38 = happySpecReduce_1  18 happyReduction_38
happyReduction_38 _
	 =  HappyAbsSyn18
		 (Javalette.Abs.Void
	)

happyReduce_39 = happySpecReduce_0  19 happyReduction_39
happyReduction_39  =  HappyAbsSyn19
		 ([]
	)

happyReduce_40 = happySpecReduce_1  19 happyReduction_40
happyReduction_40 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 ((:[]) happy_var_1
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  19 happyReduction_41
happyReduction_41 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happyReduce 5 20 happyReduction_42
happyReduction_42 (_ `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn18  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Javalette.Abs.ENew happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_43 = happyReduce 4 20 happyReduction_43
happyReduction_43 (_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Javalette.Abs.EIndex happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_44 = happySpecReduce_1  20 happyReduction_44
happyReduction_44 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  21 happyReduction_45
happyReduction_45 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.ELength happy_var_1
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  21 happyReduction_46
happyReduction_46 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.EVar happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  21 happyReduction_47
happyReduction_47 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.ELitInt happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  21 happyReduction_48
happyReduction_48 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.ELitDoub happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  21 happyReduction_49
happyReduction_49 _
	 =  HappyAbsSyn20
		 (Javalette.Abs.ELitTrue
	)

happyReduce_50 = happySpecReduce_1  21 happyReduction_50
happyReduction_50 _
	 =  HappyAbsSyn20
		 (Javalette.Abs.ELitFalse
	)

happyReduce_51 = happyReduce 4 21 happyReduction_51
happyReduction_51 (_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Javalette.Abs.EApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_52 = happySpecReduce_1  21 happyReduction_52
happyReduction_52 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.EString happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  21 happyReduction_53
happyReduction_53 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_2  22 happyReduction_54
happyReduction_54 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (Javalette.Abs.Neg happy_var_2
	)
happyReduction_54 _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_2  22 happyReduction_55
happyReduction_55 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (Javalette.Abs.Not happy_var_2
	)
happyReduction_55 _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_1  22 happyReduction_56
happyReduction_56 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  23 happyReduction_57
happyReduction_57 (HappyAbsSyn20  happy_var_3)
	(HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.EMul happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  23 happyReduction_58
happyReduction_58 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  24 happyReduction_59
happyReduction_59 (HappyAbsSyn20  happy_var_3)
	(HappyAbsSyn30  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.EAdd happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  24 happyReduction_60
happyReduction_60 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  25 happyReduction_61
happyReduction_61 (HappyAbsSyn20  happy_var_3)
	(HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.ERel happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  25 happyReduction_62
happyReduction_62 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  26 happyReduction_63
happyReduction_63 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.EAnd happy_var_1 happy_var_3
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  26 happyReduction_64
happyReduction_64 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  27 happyReduction_65
happyReduction_65 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (Javalette.Abs.EOr happy_var_1 happy_var_3
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  27 happyReduction_66
happyReduction_66 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_3  28 happyReduction_67
happyReduction_67 _
	(HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (happy_var_2
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_0  29 happyReduction_68
happyReduction_68  =  HappyAbsSyn29
		 ([]
	)

happyReduce_69 = happySpecReduce_1  29 happyReduction_69
happyReduction_69 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn29
		 ((:[]) happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  29 happyReduction_70
happyReduction_70 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn29
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  30 happyReduction_71
happyReduction_71 _
	 =  HappyAbsSyn30
		 (Javalette.Abs.Plus
	)

happyReduce_72 = happySpecReduce_1  30 happyReduction_72
happyReduction_72 _
	 =  HappyAbsSyn30
		 (Javalette.Abs.Minus
	)

happyReduce_73 = happySpecReduce_1  31 happyReduction_73
happyReduction_73 _
	 =  HappyAbsSyn31
		 (Javalette.Abs.Times
	)

happyReduce_74 = happySpecReduce_1  31 happyReduction_74
happyReduction_74 _
	 =  HappyAbsSyn31
		 (Javalette.Abs.Div
	)

happyReduce_75 = happySpecReduce_1  31 happyReduction_75
happyReduction_75 _
	 =  HappyAbsSyn31
		 (Javalette.Abs.Mod
	)

happyReduce_76 = happySpecReduce_1  32 happyReduction_76
happyReduction_76 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.LTH
	)

happyReduce_77 = happySpecReduce_1  32 happyReduction_77
happyReduction_77 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.LE
	)

happyReduce_78 = happySpecReduce_1  32 happyReduction_78
happyReduction_78 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.GTH
	)

happyReduce_79 = happySpecReduce_1  32 happyReduction_79
happyReduction_79 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.GE
	)

happyReduce_80 = happySpecReduce_1  32 happyReduction_80
happyReduction_80 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.EQU
	)

happyReduce_81 = happySpecReduce_1  32 happyReduction_81
happyReduction_81 _
	 =  HappyAbsSyn32
		 (Javalette.Abs.NE
	)

happyNewToken action sts stk [] =
	action 75 75 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 33;
	PT _ (TS _ 2) -> cont 34;
	PT _ (TS _ 3) -> cont 35;
	PT _ (TS _ 4) -> cont 36;
	PT _ (TS _ 5) -> cont 37;
	PT _ (TS _ 6) -> cont 38;
	PT _ (TS _ 7) -> cont 39;
	PT _ (TS _ 8) -> cont 40;
	PT _ (TS _ 9) -> cont 41;
	PT _ (TS _ 10) -> cont 42;
	PT _ (TS _ 11) -> cont 43;
	PT _ (TS _ 12) -> cont 44;
	PT _ (TS _ 13) -> cont 45;
	PT _ (TS _ 14) -> cont 46;
	PT _ (TS _ 15) -> cont 47;
	PT _ (TS _ 16) -> cont 48;
	PT _ (TS _ 17) -> cont 49;
	PT _ (TS _ 18) -> cont 50;
	PT _ (TS _ 19) -> cont 51;
	PT _ (TS _ 20) -> cont 52;
	PT _ (TS _ 21) -> cont 53;
	PT _ (TS _ 22) -> cont 54;
	PT _ (TS _ 23) -> cont 55;
	PT _ (TS _ 24) -> cont 56;
	PT _ (TS _ 25) -> cont 57;
	PT _ (TS _ 26) -> cont 58;
	PT _ (TS _ 27) -> cont 59;
	PT _ (TS _ 28) -> cont 60;
	PT _ (TS _ 29) -> cont 61;
	PT _ (TS _ 30) -> cont 62;
	PT _ (TS _ 31) -> cont 63;
	PT _ (TS _ 32) -> cont 64;
	PT _ (TS _ 33) -> cont 65;
	PT _ (TS _ 34) -> cont 66;
	PT _ (TS _ 35) -> cont 67;
	PT _ (TS _ 36) -> cont 68;
	PT _ (TS _ 37) -> cont 69;
	PT _ (TS _ 38) -> cont 70;
	PT _ (TV happy_dollar_dollar) -> cont 71;
	PT _ (TD happy_dollar_dollar) -> cont 72;
	PT _ (TI happy_dollar_dollar) -> cont 73;
	PT _ (TL happy_dollar_dollar) -> cont 74;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 75 tk tks = happyError' (tks, explist)
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
