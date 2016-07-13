class AdventParser
prechigh
	left NEW_LINE
	nonassoc LEFT_PARENTHESIS RIGHT_PARENTHESIS DOT
	nonassoc NOT_OP
	right POW
	nonassoc UMINUS
	left MULTIPLY DIVIDE
	left ADD SUBTRACT
	left CMP_OP CMP_EQ_OP
	left EQ_OP
	right EQUALS
preclow

rule
	expression : value 
	| NEW_LINE
	| expression NEW_LINE { return val[0] }
	| NEW_LINE expression { return val[1] }
	| expression NEW_LINE expression { return [*val[0], *val[2]] }
	| OP ADD value { return [:OP_DEF, val[1], val[2]] } # make this a value?

	opt_expression :
	| expression

	value : INTEGER { return [:INTEGER, val[0]] }
	| FLOAT { return [:FLOAT, val[0]] }
	| STRING { return [:STRING, AdventCore.str_escape(val[0])] }
	| NULL { return [:NULL, nil] }
	| bool { return [:BOOL, val[0]] }
	| assignment
	| boperator
	| uoperator
	| LEFT_PARENTHESIS value RIGHT_PARENTHESIS { return val[1] }
	| VAR { return [:VAR, val[0]] }
	| block
	| call_block
	| if_statement
	| attribute

	boperator : value POW value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value MULTIPLY value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value DIVIDE value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value ADD value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value SUBTRACT value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value EQ_OP value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value CMP_OP value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value CMP_EQ_OP value { return [:BOPERATOR, val[1], val[0], val[2]] }

	uoperator : NOT_OP value { return [:UOPERATOR, val[0], val[1]] }
	| SUBTRACT value =UMINUS { return [:UOPERATOR, val[0], val[1]] }

	bool : TRUE
	| FALSE

	attribute : value DOT VAR { return [:ATTR, val[0], val[2]] }

	assignment : VAR EQUALS value { return [:ASSIGN, val[0], val[2]] }

	block : CURLY_BRACKET_L opt_expression CURLY_BRACKET_R { return [:BLOCK, Block.new(val[1])] }
	| CURLY_BRACKET_L parameters IN opt_expression CURLY_BRACKET_R { return [:BLOCK, Block.new(val[3], val[1])] }

	call_block : value LEFT_PARENTHESIS arguments RIGHT_PARENTHESIS { return [:CALL, val[0], [:ARGS, *val[2]]] }
	| value LEFT_PARENTHESIS RIGHT_PARENTHESIS { return [:CALL, val[0], [:ARGS]] }

	if_statement : IF value block { return [:IF, val[1], val[2]] }
	| if_statement ELSE block { return [*val[0], [:ELSE, val[2]]] }

	opt_parameters :
	| parameters

	parameters : parameter { return [val[0]] }
	| parameter COMMA parameters { return [val[0], *val[2]] }

	parameter : VAR { return [:Any, val[0]] }
	# the second var in the line below should be the name of a type
	| VAR CAST VAR { return [val[2], val[0]] }

	opt_arguments :
	| arguments

	arguments : value { return [val[0]] }
	| value COMMA arguments { return [val[0], *val[2]] }

	# start_block : CURLY_BRACKET_L new_lines
	# end_block : CURLY_BRACKET_R new_lines
	# block : CURLY_BRACKET_L new_lines expression new_lines CURLY_BRACKET_R { return [:BLOCK, val[1]] }

	# literal : NUMBER
	# | STRING

end

---- header
	require_relative "lexer"
	require_relative "lib/advent_core"
	require_relative "lib/advent_classes"

---- inner
	def parse(input)
		scan_str(input)
	end

