class MyLangParser
prechigh
	left NEW_LINE
	left LEFT_PARENTHESIS RIGHT_PARENTHESIS
	left NOT_OP
	left MULTIPLY DIVIDE
	left ADD SUBTRACT
	left CMP_OP CMP_EQ_OP
	left EQ_OP
	right EQUALS
preclow

rule
	expression : value 
	| expression NEW_LINE { return val[0] }
	| NEW_LINE expression { return val[1] }
	| NEW_LINE
	| expression NEW_LINE expression { return [*val[0], *val[2]] }
	| if_statement

	value : NUMBER { return [:NUMBER, val[0]] }
	| STRING { return [:STRING, MyLangCore.str_escape(val[0])] }
	| NULL { return [:NULL, nil] }
	| bool
	# | literal { return [:LITERAL, val[0]] }
	| assignment
	# make these there own section, like: | OPERATION { return MyLangCore.binary_operator(val[0], val[2], val[1]) }
	| value MULTIPLY value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value DIVIDE value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value ADD value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value SUBTRACT value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| NOT_OP value { return [:UOPERATOR, val[0], val[1]] }
	| value EQ_OP value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value CMP_OP value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| value CMP_EQ_OP value { return [:BOPERATOR, val[1], val[0], val[2]] }
	| LEFT_PARENTHESIS value RIGHT_PARENTHESIS { return val[1] }
	| VAR { return [:VAR, val[0]] }
	| block
	| call_block

	bool : TRUE { return [:BOOL, val[0]] }
	| FALSE { return [:BOOL, val[0]] }

	assignment : VAR EQUALS value { return [:ASSIGN, val[0], val[2]] }

	block : CURLY_BRACKET_L expression CURLY_BRACKET_R { return [:BLOCK, Block.new(val[1])] }
	| CURLY_BRACKET_L parameters IN expression CURLY_BRACKET_R { return [:BLOCK, Block.new(val[3], val[1])] }


	call_block : value LEFT_PARENTHESIS arguments RIGHT_PARENTHESIS { return [:CALL, val[0], [:ARGS, *val[2]]] }
	| value LEFT_PARENTHESIS RIGHT_PARENTHESIS { return [:CALL, val[0], [:ARGS]] }

	if_statement : IF value block { return [:IF, val[1], val[2]] }
	| if_statement ELSE block { return [*val[0], [:ELSE, val[2]]] }

	opt_parameters :
	| parameters

	parameters : VAR { return [val[0]] }
	| VAR COMMA parameters { return [val[0], *val[2]] }

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
	require_relative "my_lang_core"

---- inner
	def parse(input)
		scan_str(input)
	end

