class AdventParser
macro
	BLANK [\ \t]+
	# BLANK [\s]+
	IF if
	ELSE else
	NULL null
	TRUE true
	FALSE false
	IN in\s
	OP op
	NOT_OP !
	EQ_OP (==|!=)
	CMP_EQ_OP (<=|>=)
	CMP_OP (<|>)
	CAST :
	DOT \.
	VAR [a-zA-Z_]\w*
	FLOAT \d+\.\d+
	INTEGER \d+
	POW \*\*
	MULTIPLY \*
	DIVIDE \/
	ADD \+
	SUBTRACT \-
	EQUALS =
	LEFT_PARENTHESIS \(
	RIGHT_PARENTHESIS \)
	STRING ("([^"]|\\")*?(?<!\\)")|('([^']|\\')*?(?<!\\)')
	# STRING ('[^']*?')|("[^"]*?")
	CURLY_BRACKET_L {
	CURLY_BRACKET_R }
	COMMA ,
	NEW_LINE (\n|;)
	# NEW_LINE ;
	
rule
	{IN} { [:IN, text.to_sym] }
	{BLANK} # nah
	{IF} { [:IF, nil] }
	{ELSE} { [:ELSE, nil] }
	{NULL} { [:NULL, nil] }
	{TRUE} { [:TRUE, true] }
	{FALSE} { [:FALSE, false] }
	{EQ_OP} { [:EQ_OP, text.to_sym] }
	{CMP_EQ_OP} { [:CMP_EQ_OP, text.to_sym] }
	{CMP_OP} { [:CMP_OP, text.to_sym] }
	{NOT_OP} { [:NOT_OP, text.to_sym] }
	{CAST} { [:CAST, text.to_sym] }
	{DOT} { [:DOT, text.to_sym] }
	{OP} { [:OP, text.to_sym] }
	{VAR} { [:VAR, text.to_sym] }
	{FLOAT} { [:FLOAT, Float(text)] }
	{INTEGER} { [:INTEGER, text.to_i] }
	{POW} { [:POW, text.to_sym] }
	{MULTIPLY} { [:MULTIPLY, text.to_sym] }
	{DIVIDE} { [:DIVIDE, text.to_sym] }
	{ADD} { [:ADD, text.to_sym] }
	{SUBTRACT} { [:SUBTRACT, text.to_sym] }
	{EQUALS} { [:EQUALS, text.to_sym] }
	{LEFT_PARENTHESIS} { [:LEFT_PARENTHESIS, text.to_sym] }
	{RIGHT_PARENTHESIS} { [:RIGHT_PARENTHESIS, text.to_sym] }
	{STRING} { [:STRING, text] }
	{CURLY_BRACKET_L} { [:CURLY_BRACKET_L, text.to_sym] }
	{CURLY_BRACKET_R} { [:CURLY_BRACKET_R, text.to_sym] }
	{COMMA} { [:COMMA, text.to_sym] }
	{NEW_LINE} { [:NEW_LINE, nil] }

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

