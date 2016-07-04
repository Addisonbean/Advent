require_relative "parser"

module MyLangCore

	VARIABLES = {}

	CALL_STACK = [[]]

	def MyLangCore.type_of(val)
		case val
		# when Fixnum, Bignum, Float, BigDecimal then :Number
		when Fixnum, Bignum, Float then :Number
		when String then :String
		when Array then :Block
		when NilClass then :Null
		when TrueClass, FalseClass then :Bool
		end
	end

	# make a general .operator method using map and the splat operator
	def MyLangCore.binary_operator(operator, val1, val2)
		# TODO: add errors
		# TODO: put `operators` somewhere else, trash `Value`
		op = Value.operators[[MyLangCore.type_of(val1), MyLangCore.type_of(val2), operator]]
		op = Value.operators[[:Any, MyLangCore.type_of(val2), operator]] unless op
		op = Value.operators[[MyLangCore.type_of(val1), :Any, operator]] unless op
		op = Value.operators[[:Any, :Any, operator]] unless op
		op.call(val1, val2)
	end

	def MyLangCore.unary_operator(operator, val)
		op = Value.operators[[MyLangCore.type_of(val), operator]]
		op = Value.operators[[:Any, operator]] unless op
		op.call(val)
	end

	# TODO: check if var already exists
	def MyLangCore.new_variable(name, value)
		VARIABLES[name] = value
	end

	def MyLangCore.get_var(name)
		VARIABLES[name]
	end

	# fix?
	def MyLangCore.str_escape(str)
		str[1..-2]
	end

	def MyLangCore.not(v)
		!v
	end

	# def MyLangCore.new_line
	# 	CALL_STACK << [] unless CALL_STACK[-1] == []
	# end

	# def MyLangCore.add_call(c)
	# 	CALL_STACK[-1] << c
	# end

end

class MyLang

	def initialize
		@parser = MyLangParser.new
	end

	def exec(code)
		parse(@parser.parse(code))
	end

	def parse(ary)
		val = case ary.shift
		when :NULL, :NUMBER, :BOOL, :STRING, :BLOCK # TODO? make this line: `when :LITERAL`
			ary.shift
		when :VAR
			MyLangCore.get_var(ary.shift)
		when :ASSIGN
			MyLangCore.new_variable(ary.shift, parse(ary.shift))
		when :BOPERATOR
			MyLangCore.binary_operator(ary.shift, parse(ary.shift), parse(ary.shift))
		when :UOPERATOR
			MyLangCore.unary_operator(ary.shift, parse(ary.shift))
		when :CALL
			call_block(ary.shift)
		when :IF
			if parse(ary.shift)
				res = call_block(ary.shift)
				ary.shift while ary[0] && ary[0][0] == :ELSE
				res
			else
				ary.shift
				els = ary.shift
				els ? call_block(els[1]) : nil
			end
		end
		ary.empty? ? val : parse(ary)
	end

	def call_block(b)
		parse(b[1])
	end

end

# types: "Number", "String"
class Value

	attr_accessor :value, :type

	@@operators = {
		[:Number, :Number, :+] => -> (x, y) { x + y },
		[:Number, :Number, :-] => -> (x, y) { x - y },
		[:Number, :Number, :*] => -> (x, y) { x * y },
		[:Number, :Number, :/] => -> (x, y) { x / y },
		[:String, :String, :+] => -> (x, y) { x + y },
		[:String, :Number, :*] => -> (x, y) { x * y },
		[:Any, :Any, :==] => -> (x, y) { x == y },
		[:Any, :Any, :!=] => -> (x, y) { x != y},
		[:Any, :Any, :<] => -> (x, y) { x < y },
		[:Any, :Any, :>] => -> (x, y) { x > y },
		[:Any, :Any, :<=] => -> (x, y) { x <= y },
		[:Any, :Any, :>=] => -> (x, y) { x >= y },
		[:Any, :!] => -> (x) { MyLangCore.not(x) }
	}

	def self.operators
		@@operators
	end
	
	def initialize(value, type)
		@value = value
		@type = type
	end

end

class Variable

	attr_accessor :value, :name

	def initialize(name, value)
		@name = name
		@value = value
	end

end

