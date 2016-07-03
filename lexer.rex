class MyLang
macro
	BLANK [\s]+
	VAR [a-zA-Z_]\w*
	NUMBER \d+
	MULTIPLY \*
	DIVIDE \/
	ADD \+
	SUBTRACT \-
	EQUALS =
	LEFT_PARENTHESIS \(
	RIGHT_PARENTHESIS \)
	STRING ("([^"]|\\")*?(?<!\\)")|('([^']|\\')*?(?<!\\)')
	# STRING ('[^']*?')|("[^"]*?")
	
rule
	{BLANK} # nah
	{VAR} { [:VAR, text.to_sym] }
	{NUMBER} { [:NUMBER, text.to_i] }
	{MULTIPLY} { [:MULTIPLY, text.to_sym] }
	{DIVIDE} { [:DIVIDE, text.to_sym] }
	{ADD} { [:ADD, text.to_sym] }
	{SUBTRACT} { [:SUBTRACT, text.to_sym] }
	{EQUALS} { [:EQUALS, text.to_sym] }
	{LEFT_PARENTHESIS} { [:LEFT_PARENTHESIS, text.to_sym] }
	{RIGHT_PARENTHESIS} { [:RIGHT_PARENTHESIS, text.to_sym] }
	{STRING} { [:STRING, text] }

inner
	def tokenize(code)
		scan_setup(code)
		tokens = []
		while token = next_token
			tokens << token
		end
		tokens
	end

end

