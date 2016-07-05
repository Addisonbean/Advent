require_relative "parser"

module MyLangCore

	def MyLangCore.type_of(val)
		case val
		# when Fixnum, Bignum, Float, BigDecimal then :Number
		when Fixnum, Bignum, Float then :Number
		when String then :String
		# when Array then :Block
		when Block then :Block
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

class Block

	attr_accessor :tree, :params, :scope

	def initialize(tree, params = [])
		@tree = tree
		@params = params
		@scope = nil
	end

end

class MyLang

	def initialize
		@parser = MyLangParser.new
		@global_scope = Scope.new
	end

	def exec(code)
		parse(@parser.parse(code))
	end

	def parse(ary, scope = @global_scope)
		val = case ary.shift
		when :NULL, :NUMBER, :BOOL, :STRING # TODO? make this line: `when :LITERAL`
			ary.shift
		when :BLOCK
			b = ary.shift
			b.scope = scope.make_child_scope
			b
		when :VAR
			scope[ary.shift]
		when :ASSIGN
			scope[ary.shift] = parse(ary.shift, scope)
		when :BOPERATOR
			MyLangCore.binary_operator(ary.shift, parse(ary.shift, scope), parse(ary.shift, scope))
		when :UOPERATOR
			MyLangCore.unary_operator(ary.shift, parse(ary.shift, scope))
		when :CALL
			call_block(parse(ary.shift, scope), scope, ary.shift[1..-1])
		when :IF
			if parse(ary.shift, scope)
				res = call_block(parse(ary.shift, scope), scope)
				ary.shift while ary[0] && ary[0][0] == :ELSE
				res
			else
				ary.shift
				els = ary.shift
				els ? call_block(parse(els[1], scope), scope) : nil
			end
		end
		ary.empty? ? val : parse(ary, scope)
	end

	def call_block(b, scope, args = [])
		args.each_with_index do |arg, i|
			param = b.params[i]
			b.scope.scope[param] = parse(arg, scope)
		end
		parse(b.tree, b.scope)
	end

end

class Special
end

class Scope

	VAR_NOT_FOUND = Special.new

	attr_accessor :scope, :parent_scope

	def initialize(parent_scope = nil)
		@parent_scope = parent_scope
		@scope = Hash.new(Scope::VAR_NOT_FOUND)
	end
	
	def [](var)
		val = @scope[var]
		if val == Scope::VAR_NOT_FOUND && @parent_scope
			val = @parent_scope[var]
		end
		# todo: throw error instead of returning nil
		val == Scope::VAR_NOT_FOUND ? nil : val
	end

	def []=(var, val)
		s = get_scope_of(var)
		s ? s.scope[var] = val : @scope[var] = val
	end

	def get_scope_of(var)
		correct = nil
		if @scope[var] == Scope::VAR_NOT_FOUND 
			correct = @parent_scope ? @parent_scope.get_scope_of(var) : nil
		else
			correct = self
		end
		correct
	end

	def make_child_scope
		Scope.new(self)
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
		[:Number, :Number, :**] => -> (x, y) { x ** y },
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

