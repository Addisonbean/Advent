class MyLangParser
prechigh
	left NEW_LINE
	left LEFT_PARENTHESIS
	left RIGHT_PARENTHESIS
	left MULTIPLY
	left DIVIDE
	left ADD
	left SUBTRACT
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
	| NULL { return [:NULL] }
	# | literal { return [:LITERAL, val[0]] }
	| assignment
	# make these there own section, like: | OPERATION { return MyLangCore.binary_operator(val[0], val[2], val[1]) }
	| value MULTIPLY value { return [:OPERATOR, val[1], val[0], val[2]] }
	| value DIVIDE value { return [:OPERATOR, val[1], val[0], val[2]] }
	| value ADD value { return [:OPERATOR, val[1], val[0], val[2]] }
	| value SUBTRACT value { return [:OPERATOR, val[1], val[0], val[2]] }
	| LEFT_PARENTHESIS value RIGHT_PARENTHESIS { return val[1] }
	| VAR { return [:VAR, val[0]] }
	| block
	| call_block

	assignment : VAR EQUALS value { return [:ASSIGN, val[0], val[2]] }

	block : CURLY_BRACKET_L expression CURLY_BRACKET_R { return [:BLOCK, val[1]] }

	call_block : value LEFT_PARENTHESIS RIGHT_PARENTHESIS { return [:CALL, val[0]] }

	if_statement : IF value block { return [:IF, val[1], val[2]] }
	| if_statement ELSE block { return [*val[0], [:ELSE, val[2]]] }

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

