class MyLangParser
prechigh
	left LEFT_PARENTHESIS
	left RIGHT_PARENTHESIS
	left MULTIPLY
	left DIVIDE
	left ADD
	left SUBTRACT
	right EQUALS
preclow

rule
	line: expression
	# | NEW_LINE { MyLangCore.new_line } # or nothing?
	| NEW_LINE

	expression : value

	value : NUMBER { return [:NUMBER, val[0]] }
	| STRING { return [:STRING, MyLangCore.str_escape(val[0])] }
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

	assignment : VAR EQUALS value { return [:ASSIGN, val[0], val[2]] }

	block : CURLY_BRACKET_L expression CURLY_BRACKET_R { return [:BLOCK, val[1]] }


	start_block : CURLY_BRACKET_L new_lines
	end_block : CURLY_BRACKET_R new_lines
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

