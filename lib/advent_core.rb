require_relative "../parser"
require_relative "advent_classes"
require_relative "advent_errors"

module AdventCore
	def self.str_escape(str)
		str[1..-2]
	end

	def self.display_advent_val(val)
		# TODO: change this
		val.nil? ? "null" : val.inspect
	end

	def self.type_of(val)
		case val
		when Float then :Float
		when Fixnum, Bignum then :Integer
		when String then :String
		when Block then :Block
		when NilClass then :Null
		when TrueClass, FalseClass then :Bool
		when AdventClass then :Class
		end
	end

	def self.class_for_val(val)
		case val
		when Float then FLOAT
		when Fixnum, Bignum then INTEGER
		when String then STRING
		when Block then BLOCK
		when NilClass then NULL
		when TrueClass, FalseClass then BOOLEAN
		when AdventClass then AdventClass
		end
	end
end

class Block

	attr_accessor :tree, :params, :scope

	def initialize(tree, params = [])
		@tree = tree
		# params: [[:Type, :name], ...]
		# ps: `:Type` may not really exists or be a type
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
		init_scope
	end

	# DANGEROUS
	def exec(code)
		parse(@parser.parse(code))
	end

	# NEVER call `parse` without supplying `scope` except in `exec`
	# DANGEROUS
	def parse(ary, scope = @global_scope)
		token = ary.shift
		val = case token
		# [:TYPE, ruby_value]
		when :NULL, :INTEGER, :FLOAT, :BOOL, :STRING # TODO? make this line: `when :LITERAL`? Probably not, idk
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
			sym = ary.shift
			v = parse(ary.shift, scope)
			return EXIT if v == EXIT
			scope[sym] = v
		# [:BOPERATOR, Symbol, [value], [value]]
		when :BOPERATOR
			op_sym = ary.shift
			val1 = parse(ary.shift, scope)
			return EXIT if val1 == EXIT

			val2 = parse(ary.shift, scope)
			return EXIT if val2 == EXIT

			op = find_op(op_sym, [AdventCore.class_for_val(val1), AdventCore.class_for_val(val2)])
			return EXIT if op == EXIT

			if op.is_a?(Block)
				v = call_block(op, scope, [val1, val2], false)
				return EXIT if v == EXIT
				v
			else
				op.call(val1, val2)
			end
		# [:UOPERATOR, [value]]
		when :UOPERATOR
			unary_operator(ary.shift, parse(ary.shift, scope))
		# [:CALL, [block_value], [:ARGS, [arg1_value], [arg2_value], ...]]
		when :CALL
			blk = parse(ary.shift, scope)
			return EXIT if blk == EXIT
			v = call_block(blk, scope, ary.shift[1..-1])
			return EXIT if v == EXIT
			v
		# [:IF, [cond_value], [block_value]] ||
		# [:IF, [cond_value], [block_value], [:ELSE, [block_value]]]
		when :IF
			cond = parse(ary.shift, scope)
			return EXIT if cond == EXIT
			if cond
				blk = parse(ary.shift, scope)
				return EXIT if blk == EXIT

				res = call_block(blk, scope)
				return EXIT if res == EXIT

				ary.shift while ary[0] && ary[0][0] == :ELSE
				res
			else
				ary.shift
				els = ary.shift
				if els
					blk = parse(els[1], scope)
					return EXIT if blk == EXIT

					v = call_block(blk, scope)
					return EXIT if v == EXIT
					v
				else
					nil
				end
			end
		# [:OP_DEF, Symbol, [block_value]]
		when :OP_DEF
			op = ary.shift
			blk = parse(ary.shift, scope)
			return EXIT if blk == EXIT
			cs = blk.params.map do |p|
				AdventClass::CLASS_LIST[p[0]]
			end
			ops = @operators[op]
			# check for similar operator? like [int, any] vs [any, int]?
			ops.reject! { |the_op| the_op[0] == cs }
			ops << [cs, blk]
		# [:ATTR, [value], Symbol]
		# when :ATTR
		# 	val = parse(ary.shift, scope)
		# 	return EXIT if val == EXIT
		# 	klass = AdventCore.class_for_val(val)
		# 	res = klass.attr

		else 
			return ADVENT_PARSE_E.raise("Unrecognized token: #{token}.")
		end
		ary.empty? ? val : parse(ary, scope)
	end

	# DANGEROUS
	def call_block(b, scope, args = [], parse_args = true)
		unless AdventCore.type_of(b) == :Block
			return ADVENT_REFERENCE_E.raise("`#{AdventCore.display_advent_val(b)}' is not a block.")
		end
		return nil unless b.tree
		args.each_with_index do |arg, i|
			param = b.params[i][1]
			b.scope.real_scope[param] = if parse_args
				v = parse(arg, scope)
				return EXIT if v == EXIT
				v
			else
				arg
			end
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

	def unary_operator(operator, val)
		op = @operators[[AdventCore.type_of(val), operator]]
		op = @operators[[:Any, operator]] unless op
		op.call(val)
	end

	# sorry :(
	# todo: simplify/use for unary and ternery operators
	# DANGEROUS
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
			return ADVENT_ARGUMENT_E.raise("No operator named `#{op}' with type `(#{classes.map(&:name).join(", ")})' found.")
		elsif res.count > 1
			return ADVENT_OP_CONFLICT_E.raise("Unable to determine correct block for operator `#{op} (#{classes.map(&:name).join(", ")})'. Possible block types: #{
				res.map do |a| op
					op_match = @operators[op][a[0]]
					"`(#{op_match[0].map(&:name).join(", ")})'"
				end.join(", ")
			}.")
		end
		matches[res[0][0]][1]
	end

	def init_scope
		@global_scope[:Any] = ANY
		@global_scope[:Number] = NUMBER
		@global_scope[:Integer] = INTEGER
		@global_scope[:Float] = FLOAT
		@global_scope[:String] = STRING
		@global_scope[:Block] = BLOCK
		@global_scope[:Null] = NULL
		@global_scope[:Boolean] = BOOLEAN
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
			return ADVENT_REFERENCE_E.raise("Undefined variable `#{var}'.")
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

