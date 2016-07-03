class MyLang
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
	expression : value

	value : NUMBER { return Value.new(val[0], "Number") }
	| STRING { return Value.new(MyLangCore.str_escape(val[0]), "String") }
	| assignment
	# make these there own section, like: | OPERATION { return MyLangCore.binary_operator(val[0], val[2], val[1]) }
	| value MULTIPLY value { return MyLangCore.binary_operator(val[0], val[2], val[1]) }
	| value DIVIDE value { return MyLangCore.binary_operator(val[0], val[2], val[1]) }
	| value ADD value { return MyLangCore.binary_operator(val[0], val[2], val[1]) }
	| value SUBTRACT value { return MyLangCore.binary_operator(val[0], val[2], val[1]) }
	| LEFT_PARENTHESIS value RIGHT_PARENTHESIS { return val[1] }
	| VAR { return MyLangCore.get_var(val[0]) }

	assignment : VAR EQUALS value { return MyLangCore.new_variable(val[0], val[2]) }

end

---- header
	require_relative "lexer"
	require_relative "my_lang_core"

---- inner
	def parse(input)
		scan_str(input)
	end

