#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

	require_relative "lexer"
	require_relative "my_lang_core"

class MyLangParser < Racc::Parser

module_eval(<<'...end parser.y/module_eval...', 'parser.y', 87)
	def parse(input)
		scan_str(input)
	end
...end parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    32,    23,    23,    32,    24,    25,    26,    27,    28,    30,
    31,    29,     3,    12,    32,    22,    16,    23,    24,    25,
    26,    17,    59,    69,    63,    32,     5,     6,     7,    13,
    18,    19,    20,     3,    12,    21,    32,    16,    20,    32,
    24,    64,    17,    24,    25,    26,    36,     5,     6,     7,
    13,    18,    19,    20,     3,    12,    21,    32,    16,    65,
    32,    24,    61,    17,    24,    43,    60,    36,     5,     6,
     7,    40,    18,    19,    20,    12,   -39,    21,    16,    60,
    34,   nil,   nil,    17,   nil,   nil,   nil,   nil,     5,     6,
     7,    13,    18,    19,    20,    12,   nil,    21,    16,   nil,
   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,     5,     6,
     7,    13,    18,    19,    20,    12,   nil,    21,    16,   nil,
   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,     5,     6,
     7,    13,    18,    19,    20,    12,   nil,   nil,    16,   nil,
   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,     5,     6,
     7,    13,    18,    19,    20,    12,   nil,   nil,    16,   nil,
   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,     5,     6,
     7,    13,    18,    19,    20,    12,   nil,   nil,    16,   nil,
   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,     5,     6,
     7,    13,    18,    19,    20,    32,   nil,   nil,   nil,    24,
    25,    26,    27,    28,    30,    31,    29,    12,   nil,   nil,
    16,   nil,   nil,   nil,    20,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,    55,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    12,   nil,   nil,
    16,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
     5,     6,     7,    13,    18,    19,    20,    32,   nil,   nil,
   nil,    24,    25,    26,    27,    28,    30,    31,    29,    32,
   nil,   nil,   nil,    24,    25,    26,    27,    28,    30,    31,
    29,    32,    57,   nil,   nil,    24,    25,    26,    27,    28,
    30,    31,    29,    32,   nil,   nil,   nil,    24,    25,    26,
    27,    28,    30,    31,    32,   nil,   nil,   nil,    24,    25,
    26,    27,    28,    32,   nil,   nil,   nil,    24,    25,    26,
    27,    28 ]

racc_action_check = [
    53,    39,    67,    38,    53,    53,    53,    53,    53,    53,
    53,    53,     0,     0,    48,     1,     0,     1,    48,    48,
    48,     0,    39,    67,    53,    37,     0,     0,     0,     0,
     0,     0,     0,    61,    61,     0,    45,    61,    34,    49,
    45,    54,    61,    49,    49,    49,    13,    61,    61,    61,
    61,    61,    61,    61,    20,    20,    61,    47,    20,    60,
    46,    47,    41,    20,    46,    22,    65,    40,    20,    20,
    20,    20,    20,    20,    20,     3,    40,    20,     3,    40,
     4,   nil,   nil,     3,   nil,   nil,   nil,   nil,     3,     3,
     3,     3,     3,     3,     3,    23,   nil,     3,    23,   nil,
   nil,   nil,   nil,    23,   nil,   nil,   nil,   nil,    23,    23,
    23,    23,    23,    23,    23,    17,   nil,    23,    17,   nil,
   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,    17,    17,
    17,    17,    17,    17,    17,    16,   nil,   nil,    16,   nil,
   nil,   nil,   nil,    16,   nil,   nil,   nil,   nil,    16,    16,
    16,    16,    16,    16,    16,    21,   nil,   nil,    21,   nil,
   nil,   nil,   nil,    21,   nil,   nil,   nil,   nil,    21,    21,
    21,    21,    21,    21,    21,    63,   nil,   nil,    63,   nil,
   nil,   nil,   nil,    63,   nil,   nil,   nil,   nil,    63,    63,
    63,    63,    63,    63,    63,    42,   nil,   nil,   nil,    42,
    42,    42,    42,    42,    42,    42,    42,    24,   nil,   nil,
    24,   nil,   nil,   nil,    42,    24,   nil,   nil,   nil,   nil,
    24,    24,    24,    24,    24,    24,    24,    25,   nil,   nil,
    25,   nil,   nil,   nil,   nil,    25,   nil,   nil,   nil,   nil,
    25,    25,    25,    25,    25,    25,    25,    26,   nil,   nil,
    26,   nil,   nil,   nil,   nil,    26,   nil,   nil,   nil,   nil,
    26,    26,    26,    26,    26,    26,    26,    27,   nil,   nil,
    27,   nil,   nil,   nil,   nil,    27,   nil,   nil,   nil,   nil,
    27,    27,    27,    27,    27,    27,    27,    12,   nil,   nil,
    12,   nil,   nil,   nil,   nil,    12,   nil,   nil,   nil,   nil,
    12,    12,    12,    12,    12,    12,    12,    29,   nil,   nil,
    29,   nil,   nil,   nil,   nil,    29,   nil,   nil,   nil,   nil,
    29,    29,    29,    29,    29,    29,    29,    30,   nil,   nil,
    30,   nil,   nil,   nil,   nil,    30,   nil,   nil,   nil,   nil,
    30,    30,    30,    30,    30,    30,    30,    31,   nil,   nil,
    31,   nil,   nil,   nil,   nil,    31,   nil,   nil,   nil,   nil,
    31,    31,    31,    31,    31,    31,    31,    32,    32,   nil,
    32,   nil,   nil,   nil,   nil,    32,   nil,   nil,   nil,   nil,
    32,    32,    32,    32,    32,    32,    32,    36,   nil,   nil,
    36,   nil,   nil,   nil,   nil,    36,   nil,   nil,   nil,   nil,
    36,    36,    36,    36,    36,    36,    36,    28,   nil,   nil,
    28,   nil,   nil,   nil,   nil,    28,   nil,   nil,   nil,   nil,
    28,    28,    28,    28,    28,    28,    28,    58,   nil,   nil,
   nil,    58,    58,    58,    58,    58,    58,    58,    58,     2,
   nil,   nil,   nil,     2,     2,     2,     2,     2,     2,     2,
     2,    35,    35,   nil,   nil,    35,    35,    35,    35,    35,
    35,    35,    35,    50,   nil,   nil,   nil,    50,    50,    50,
    50,    50,    50,    50,    52,   nil,   nil,   nil,    52,    52,
    52,    52,    52,    51,   nil,   nil,   nil,    51,    51,    51,
    51,    51 ]

racc_action_pointer = [
    10,    15,   436,    72,    54,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   284,    31,   nil,   nil,   132,   112,   nil,   nil,
    52,   152,    65,    92,   204,   224,   244,   264,   404,   304,
   324,   344,   364,   nil,    16,   448,   384,    22,     0,    -1,
    52,    38,   192,   nil,   nil,    33,    57,    54,    11,    36,
   460,   480,   471,    -3,    37,   nil,   nil,   nil,   424,   nil,
    40,    31,   nil,   172,   nil,    39,   nil,     0,   nil,   nil ]

racc_action_default = [
   -45,   -45,    -1,    -4,    -6,    -7,    -8,    -9,   -10,   -11,
   -12,   -13,   -45,   -15,   -16,   -17,   -45,   -45,   -28,   -29,
   -45,   -45,   -45,    -2,   -45,   -45,   -45,   -45,   -45,   -45,
   -45,   -45,   -45,    -3,   -45,   -45,   -45,   -26,   -27,   -45,
   -15,   -45,   -45,    70,    -5,   -18,   -19,   -20,   -21,   -22,
   -23,   -24,   -25,   -43,   -45,   -34,   -36,   -14,   -30,   -31,
   -45,   -45,   -35,   -45,   -33,   -39,   -40,   -45,   -44,   -32 ]

racc_goto_table = [
     1,    41,    54,    33,   nil,    56,   nil,   nil,   nil,   nil,
   nil,   nil,    35,    62,   nil,   nil,    37,    38,   nil,   nil,
    39,    42,   nil,    44,    45,    46,    47,    48,    49,    50,
    51,    52,    53,    68,   nil,   nil,    58,   nil,   nil,   nil,
   nil,    66,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    67,   nil,    53 ]

racc_goto_check = [
     1,    10,    11,     1,   nil,     8,   nil,   nil,   nil,   nil,
   nil,   nil,     2,     8,   nil,   nil,     2,     2,   nil,   nil,
     1,     2,   nil,     1,     2,     2,     2,     2,     2,     2,
     2,     2,     2,    11,   nil,   nil,     2,   nil,   nil,   nil,
   nil,    10,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     1,   nil,     2 ]

racc_goto_pointer = [
   nil,     0,     0,   nil,   nil,   nil,   nil,   nil,   -29,   nil,
   -19,   -30,   nil,   nil ]

racc_goto_default = [
   nil,   nil,     2,     4,     8,     9,    10,    11,    14,    15,
   nil,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 29, :_reduce_none,
  2, 29, :_reduce_2,
  2, 29, :_reduce_3,
  1, 29, :_reduce_none,
  3, 29, :_reduce_5,
  1, 29, :_reduce_none,
  1, 30, :_reduce_7,
  1, 30, :_reduce_8,
  1, 30, :_reduce_9,
  1, 30, :_reduce_10,
  1, 30, :_reduce_none,
  1, 30, :_reduce_none,
  1, 30, :_reduce_none,
  3, 30, :_reduce_14,
  1, 30, :_reduce_15,
  1, 30, :_reduce_none,
  1, 30, :_reduce_none,
  3, 34, :_reduce_18,
  3, 34, :_reduce_19,
  3, 34, :_reduce_20,
  3, 34, :_reduce_21,
  3, 34, :_reduce_22,
  3, 34, :_reduce_23,
  3, 34, :_reduce_24,
  3, 34, :_reduce_25,
  2, 35, :_reduce_26,
  2, 35, :_reduce_27,
  1, 32, :_reduce_none,
  1, 32, :_reduce_none,
  3, 33, :_reduce_30,
  3, 36, :_reduce_31,
  5, 36, :_reduce_32,
  4, 37, :_reduce_33,
  3, 37, :_reduce_34,
  3, 31, :_reduce_35,
  3, 31, :_reduce_36,
  0, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 38, :_reduce_39,
  3, 38, :_reduce_40,
  0, 41, :_reduce_none,
  1, 41, :_reduce_none,
  1, 39, :_reduce_43,
  3, 39, :_reduce_44 ]

racc_reduce_n = 45

racc_shift_n = 70

racc_token_table = {
  false => 0,
  :error => 1,
  :NEW_LINE => 2,
  :LEFT_PARENTHESIS => 3,
  :RIGHT_PARENTHESIS => 4,
  :UMINUS => 5,
  :NOT_OP => 6,
  :POW => 7,
  :MULTIPLY => 8,
  :DIVIDE => 9,
  :ADD => 10,
  :SUBTRACT => 11,
  :CMP_OP => 12,
  :CMP_EQ_OP => 13,
  :EQ_OP => 14,
  :EQUALS => 15,
  :NUMBER => 16,
  :STRING => 17,
  :NULL => 18,
  :VAR => 19,
  :TRUE => 20,
  :FALSE => 21,
  :CURLY_BRACKET_L => 22,
  :CURLY_BRACKET_R => 23,
  :IN => 24,
  :IF => 25,
  :ELSE => 26,
  :COMMA => 27 }

racc_nt_base = 28

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "NEW_LINE",
  "LEFT_PARENTHESIS",
  "RIGHT_PARENTHESIS",
  "UMINUS",
  "NOT_OP",
  "POW",
  "MULTIPLY",
  "DIVIDE",
  "ADD",
  "SUBTRACT",
  "CMP_OP",
  "CMP_EQ_OP",
  "EQ_OP",
  "EQUALS",
  "NUMBER",
  "STRING",
  "NULL",
  "VAR",
  "TRUE",
  "FALSE",
  "CURLY_BRACKET_L",
  "CURLY_BRACKET_R",
  "IN",
  "IF",
  "ELSE",
  "COMMA",
  "$start",
  "expression",
  "value",
  "if_statement",
  "bool",
  "assignment",
  "boperator",
  "uoperator",
  "block",
  "call_block",
  "parameters",
  "arguments",
  "opt_parameters",
  "opt_arguments" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

module_eval(<<'.,.,', 'parser.y', 15)
  def _reduce_2(val, _values, result)
     return val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 16)
  def _reduce_3(val, _values, result)
     return val[1] 
    result
  end
.,.,

# reduce 4 omitted

module_eval(<<'.,.,', 'parser.y', 18)
  def _reduce_5(val, _values, result)
     return [*val[0], *val[2]] 
    result
  end
.,.,

# reduce 6 omitted

module_eval(<<'.,.,', 'parser.y', 21)
  def _reduce_7(val, _values, result)
     return [:NUMBER, val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 22)
  def _reduce_8(val, _values, result)
     return [:STRING, MyLangCore.str_escape(val[0])] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 23)
  def _reduce_9(val, _values, result)
     return [:NULL, nil] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 24)
  def _reduce_10(val, _values, result)
     return [:BOOL, val[0]] 
    result
  end
.,.,

# reduce 11 omitted

# reduce 12 omitted

# reduce 13 omitted

module_eval(<<'.,.,', 'parser.y', 28)
  def _reduce_14(val, _values, result)
     return val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 29)
  def _reduce_15(val, _values, result)
     return [:VAR, val[0]] 
    result
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

module_eval(<<'.,.,', 'parser.y', 34)
  def _reduce_18(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 35)
  def _reduce_19(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 36)
  def _reduce_20(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 37)
  def _reduce_21(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 38)
  def _reduce_22(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 39)
  def _reduce_23(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 40)
  def _reduce_24(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 41)
  def _reduce_25(val, _values, result)
     return [:BOPERATOR, val[1], val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 43)
  def _reduce_26(val, _values, result)
     return [:UOPERATOR, val[0], val[1]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 44)
  def _reduce_27(val, _values, result)
     return [:UOPERATOR, val[0], val[1]] 
    result
  end
.,.,

# reduce 28 omitted

# reduce 29 omitted

module_eval(<<'.,.,', 'parser.y', 49)
  def _reduce_30(val, _values, result)
     return [:ASSIGN, val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 51)
  def _reduce_31(val, _values, result)
     return [:BLOCK, Block.new(val[1])] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 52)
  def _reduce_32(val, _values, result)
     return [:BLOCK, Block.new(val[3], val[1])] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 54)
  def _reduce_33(val, _values, result)
     return [:CALL, val[0], [:ARGS, *val[2]]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 55)
  def _reduce_34(val, _values, result)
     return [:CALL, val[0], [:ARGS]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 57)
  def _reduce_35(val, _values, result)
     return [:IF, val[1], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 58)
  def _reduce_36(val, _values, result)
     return [*val[0], [:ELSE, val[2]]] 
    result
  end
.,.,

# reduce 37 omitted

# reduce 38 omitted

module_eval(<<'.,.,', 'parser.y', 63)
  def _reduce_39(val, _values, result)
     return [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 64)
  def _reduce_40(val, _values, result)
     return [val[0], *val[2]] 
    result
  end
.,.,

# reduce 41 omitted

# reduce 42 omitted

module_eval(<<'.,.,', 'parser.y', 69)
  def _reduce_43(val, _values, result)
     return [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 70)
  def _reduce_44(val, _values, result)
     return [val[0], *val[2]] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class MyLangParser
