require_relative "../parser"
require_relative "advent_classes"
require_relative "advent_errors"

module AdventCore
	def AdventCore.str_escape(str)
		str[1..-2]
	end
end

class Block

	attr_accessor :tree, :params, :scope

	def initialize(tree, params = [])
		@tree = tree
		# params: [[:Type, :name], ...]
		@params = params
		@scope = nil
	end

end

class Advent

	attr_accessor :parser, :global_scope

	def initialize
		@parser = AdventParser.new
		@global_scope = Scope.new
		init_operators
	end

	def exec(code)
		parse(@parser.parse(code))
	end

	# NEVER call `parse` without supplying `scope` except in `exec`
	def parse(ary, scope = @global_scope)
		token = ary.shift
		val = case token
		# [:TYPE, ruby_value]
		when :NULL, :INTEGER, :FLOAT, :BOOL, :STRING # TODO? make this line: `when :LITERAL`
			ary.shift
		# [:BLOCK, Block]
		when :BLOCK
			b = ary.shift
			b.scope = scope.make_child_scope
			b
		# [:VAR, Symbol]
		when :VAR
			scope[ary.shift]
		# [:ASSIGN, Symbol, [value]]
		when :ASSIGN
			scope[ary.shift] = parse(ary.shift, scope)
		# [:BOPERATOR, Symbol, [value], [value]]
		when :BOPERATOR
			op_sym = ary.shift
			val1 = parse(ary.shift, scope)
			val2 = parse(ary.shift, scope)
			op = find_op(op_sym, [class_for_val(val1), class_for_val(val2)])
			op.is_a?(Block) ? call_block(op, scope, [val1, val2], false) : op.call(val1, val2)
		# [:UOPERATOR, [value]]
		when :UOPERATOR
			unary_operator(ary.shift, parse(ary.shift, scope))
		# [:CALL, [block_value], [:ARGS, [arg1_value], [arg2_value], ...]]
		when :CALL
			call_block(parse(ary.shift, scope), scope, ary.shift[1..-1])
		# [:IF, [cond_value], [block_value]] ||
		# [:IF, [cond_value], [block_value], [:ELSE, [block_value]]]
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
		# [:OP_DEF, Symbol, [block_value]]
		when :OP_DEF
			op = ary.shift
			blk = parse(ary.shift, scope)
			cs = blk.params.map do |p|
				AdventClass::CLASS_LIST[p[0]]
			end
			ops = @operators[op]
			# check for similar operator? like [int, any] vs [any, int]?
			ops.reject! { |the_op| the_op[0] == cs }
			ops << [cs, blk]
		else 
			ADVENT_PARSE_E.raise("Unrecognized token: #{token}.")
		end
		ary.empty? ? val : parse(ary, scope)
	end

	def call_block(b, scope, args = [], parse_args = true)
		args.each_with_index do |arg, i|
			param = b.params[i][1]
			b.scope.real_scope[param] = parse_args ? parse(arg, scope) : arg
		end
		parse(b.tree, b.scope)
	end

	def init_operators
		@operators = {
			:+ => [
				[[NUMBER, NUMBER], -> (x, y) { x + y } ],
				[[STRING, STRING], -> (x, y) { x + y } ]
			],
			:- => [
				[[NUMBER, NUMBER], -> (x, y) { x - y } ]
			],
			:* => [
				[[NUMBER, NUMBER], -> (x, y) { x * y } ],
				[[STRING, INTEGER], -> (x, y) { x * y } ]
			],
			:/ => [
				[[NUMBER, NUMBER], -> (x, y) { x / y } ]
			],
			:** => [
				[[NUMBER, NUMBER], -> (x, y) { x ** y } ]
			],
			:== => [
				[[ANY, ANY], -> (x, y) { x == y } ]
			],
			:!= => [
				[[ANY, ANY], -> (x, y) { x != y } ]
			],
			:< => [
				[[ANY, ANY], -> (x, y) { x < y } ]
			],
			:> => [
				[[ANY, ANY], -> (x, y) { x > y } ]
			],
			:<= => [
				[[ANY, ANY], -> (x, y) { x <= y } ]
			],
			:>= => [
				[[ANY, ANY], -> (x, y) { x >= y } ]
			],
			[:Any, :!] => -> (x) { !x },
			# [:Any, :!] => -> (x) { not(x) },
			[:Integer, :-] => -> (x) { -x },
			[:Float, :-] => -> (x) { -x }
		}
	end

	def type_of(val)
		case val
		when Float then :Float
		when Fixnum, Bignum then :Integer
		when String then :String
		when Block then :Block
		when NilClass then :Null
		when TrueClass, FalseClass then :Bool
		end
	end

	def class_for_val(val)
		case val
		when Float then FLOAT
		when Fixnum, Bignum then INTEGER
		when String then STRING
		when Block then BLOCK
		when NilClass then NULL
		when TrueClass, FalseClass then BOOLEAN
		end
	end

	def unary_operator(operator, val)
		op = @operators[[type_of(val), operator]]
		op = @operators[[:Any, operator]] unless op
		op.call(val)
	end

	# sorry :(
	# todo: simplify/use for unary and ternery operators
	def find_op(op, classes)
		arity = classes.count
		# matches: [ [[TYPE, TYPE], block], [[TYPE, TYPE], block], ... ]
		matches = @operators[op].select { |o| o[0].count == arity }

		# [ [0, [a, b]], [1, [a, b]], [2, [a, b]], ... ]
		dists = matches.each_with_index.map do |o, idx|
			ranking = o[0].each_with_index.map do |c, i|
				classes[i].distance_from(c)
			end
			[idx, ranking]
		end
		dists.select! { |a| a[1].all? { |e| e >= 0 } }
		idx_min_max = []
		most_min = Float::INFINITY
		min_max = Float::INFINITY
		# [ [0, [min, max]], [1, [min, max]], ...]
		res = dists.map do |d|
			most_min = [most_min, d[1].min].min
			[d[0], [d[1].min, d[1].max]]
		end.select do |d|
			min_max = [min_max, d[1][1]].min
			most_min == d[1][0]
		end
		res = res.select { |d| min_max == d[1][1] } if res.count > 1
		if res.count < 1
			ADVENT_ARGUMENT_E.raise("No operator named `#{op}' with type `(#{classes.map(&:name).join(", ")})' found.")
		elsif res.count > 1
			ADVENT_OP_CONFLICT_E.raise("Unable to determine correct block for operator `#{op} (#{classes.map(&:name).join(", ")})'. Possible block types: #{
				res.map do |a| op
					op_match = @operators[op][a[0]]
					"`(#{op_match[0].map(&:name).join(", ")})'"
				end.join(", ")
			}.")
		end
		matches[res[0][0]][1]
	end

end

class Scope

	VAR_NOT_FOUND = NONE

	attr_accessor :scope, :parent_scope, :real_scope

	def initialize(parent_scope = nil)
		@parent_scope = parent_scope
		@real_scope = Hash.new(Scope::VAR_NOT_FOUND)
	end
	
	def [](var)
		val = get(var)
		if val == Scope::VAR_NOT_FOUND
			ADVENT_REFERENCE_E.raise("Undefined variable `#{var}'.")
		else
			val
		end
	end
	
	def get(var)
		val = @real_scope[var]
		val = @parent_scope.get(var) if val == Scope::VAR_NOT_FOUND && @parent_scope
		val
	end

	def []=(var, val)
		s = get_scope_of(var)
		s ? s.real_scope[var] = val : @real_scope[var] = val
	end

	def get_scope_of(var)
		correct = nil
		if @real_scope[var] == Scope::VAR_NOT_FOUND 
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

