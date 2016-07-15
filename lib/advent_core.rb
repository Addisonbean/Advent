require_relative "../parser"
require_relative "advent_classes"
require_relative "advent_errors"
require_relative "advent_blocks"

module AdventCore
	def self.str_escape(str)
		str[1..-2]
	end

	def self.truthy(val)
		!!val.rb_val
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

	def self.class_for_symbol(sym)
		case sym
		when :ANY then ANY
		when :FLOAT then FLOAT
		when :INTEGER then INTEGER
		when :STRING then STRING
		when :BLOCK then BLOCK
		when :NULL then NULL
		when :BOOL then BOOLEAN
		# when :CLASS then CLASS # is this neccessary? is the :ANY case neccessary either?
		end
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
		when :NULL, :INTEGER, :FLOAT, :BOOL, :STRING
			AdventValue.new(ary.shift, AdventCore.class_for_symbol(token))
		# [:BLOCK, Block]
		when :BLOCK
			b = ary.shift
			b.scope = scope.make_child_scope
			AdventValue.new(b, BLOCK)
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

			op = find_op(op_sym, [val1.klass, val2.klass])
			return EXIT if op == EXIT

			if op.is_a?(AdventValue)
				v = call_block(op, scope, [val1, val2], false)
				return EXIT if v == EXIT
				v
			else
				op.call(val1, val2)
			end
		# [:UOPERATOR, [value]]
		when :UOPERATOR
			op = ary.shift
			val = parse(ary.shift, scope)
			return EXIT if val == EXIT
			unary_operator(op, val)
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
			if AdventCore.truthy(cond)
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
					AdventValue.new(nil, NULL)
				end
			end
		# [:OP_DEF, Symbol, [block_value]]
		when :OP_DEF
			op = ary.shift
			blk = parse(ary.shift, scope)
			return EXIT if blk == EXIT
			cs = blk.rb_val.params.map do |p|
				AdventClass::CLASS_LIST[p[0]]
			end
			ops = @operators[op]
			# check for similar operator? like [int, any] vs [any, int]?
			ops.reject! { |the_op| the_op[0] == cs }
			ops << [cs, blk]
		# [:ATTR, [value], Symbol]
		when :ATTR
			val = parse(ary.shift, scope)
			return EXIT if val == EXIT
			val.attr(ary.shift)
		# [:ATTR_ASSIGN, [:ATTR, [value], Symbol], [value]]
		when :ATTR_ASSIGN
			attr_thing = ary.shift
			val = parse(attr_thing[1], scope)
			return EXIT if val == EXIT

			aval = parse(ary.shift, scope)
			return EXIT if aval == EXIT

			val.set_attr(attr_thing[2], aval)
		else 
			return ADVENT_PARSE_E.raise("Unrecognized token: #{token}.")
		end
		ary.empty? ? val : parse(ary, scope)
	end

	# TODO: refactor
	# DANGEROUS
	def call_block(blk, scope, args = [], parse_args = true)
		unless blk.klass == BLOCK
			return ADVENT_REFERENCE_E.raise("`#{AdventCore.display_advent_val(b)}' is not a block.")
		end
		b = blk.rb_val
		slef = blk.parent
		return nil unless b.tree
		if b.is_rb_block
			parsed_args = args
			if parse_args
				parsed_args.map do |ar|
					ar = parse(ar, scope)
					return EXIT if ar == EXIT
					ar
				end
			end
			parsed_args.unshift(slef) if slef
			b.tree.call(*parsed_args)
		else
			args.each_with_index do |arg, i|
				param = b.params[i][1]
				b.scope.real_scope[param] = if parse_args
					v = parse(arg, scope)
					return EXIT if v == EXIT
					v
				else
					arg
				end
				b.scope.real_scope[:self] = slef if slef
			end
			parse(b.tree, b.scope)
		end
	end

	def init_operators
		@operators = {
			:+ => [
				[[NUMBER, NUMBER], -> (x, y) { AdventValue.new(x.rb_val + y.rb_val, x.klass <=> y.klass) } ],
				[[STRING, STRING], -> (x, y) { AdventValue.new(x.rb_val + y.rb_val, STRING) } ]
			],
			:- => [
				[[NUMBER, NUMBER], -> (x, y) { AdventValue.new(x.rb_val - y.rb_val, x.klass <=> y.klass) } ]
			],
			:* => [
				[[NUMBER, NUMBER], -> (x, y) { AdventValue.new(x.rb_val * y.rb_val, x.klass <=> y.klass) } ],
				[[STRING, INTEGER], -> (x, y) { AdventValue.new(x.rb_val * y.rb_val, STRING) } ]
			],
			:/ => [
				[[NUMBER, NUMBER], -> (x, y) { AdventValue.new(x.rb_val / y.rb_val, x.klass <=> y.klass) } ]
			],
			:** => [
				[[NUMBER, NUMBER], -> (x, y) { AdventValue.new(x.rb_val ** y.rb_val, x.klass <=> y.klass) } ]
			],
			:== => [
				[[ANY, ANY], -> (x, y) { AdventValue.new(x.rb_val == y.rb_val, BOOLEAN) } ]
			],
			:!= => [
				[[ANY, ANY], -> (x, y) { AdventValue.new(x.rb_val != y.rb_val, BOOLEAN) } ]
			],
			:< => [
				[[ANY, ANY], -> (x, y) { AdventValue.new(x.rb_val < y.rb_val, BOOLEAN) } ]
			],
			:> => [
				[[ANY, ANY], -> (x, y) { AdventValue.new(x.rb_val > y.rb_val, BOOLEAN) } ]
			],
			:<= => [
				[[ANY, ANY], -> (x, y) { AdventValue.new(x.rb_val <= y.rb_val, BOOLEAN) } ]
			],
			:>= => [
				[[ANY, ANY], -> (x, y) { AdventValue.new(x.rb_val >= y.rb_val, BOOLEAN) } ]
			],
			[:Any, :!] => -> (x) { AdventValue.new(!x.rb_val, BOOLEAN) },
			# [:Any, :!] => -> (x) { not(x) },
			[:Integer, :-] => -> (x) { AdventValue.new(-x.rb_val, x.klass) },
			[:Float, :-] => -> (x) { AdventValue.new(-x.rb_val, x.klass) }
		}
	end

	def unary_operator(operator, val)
		op = @operators[[AdventCore.type_of(val.rb_val), operator]]
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

