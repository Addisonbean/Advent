require_relative "advent_value"
require_relative "advent_blocks"

class AdventClass

	attr_accessor :name, :subclass, :superclasses, :attributes

	CLASS_LIST = {}

	def initialize(name, subclass = nil, add_to_list = true)
		@name = name
		@subclass = subclass
		@subclass.superclasses << self if @subclass
		@superclasses = []
		@attributes = {}
		CLASS_LIST[name] = self if add_to_list
	end

	def distance_from(other_class, dist = 0)
		return -1 if !@subclass && other_class.subclass
		other_class == self ? dist : @subclass.distance_from(other_class, dist + 1)
	end

	def <=>(other)
		case [self, other]
		when [INTEGER, INTEGER] then INTEGER
		when [FLOAT, FLOAT] then FLOAT
		when [INTEGER, FLOAT] then FLOAT
		when [FLOAT, INTEGER] then FLOAT
		else
			dist1 = distance_from(ANY)
			dist2 = other.distance_from(ANY)
			dist1 >= dist2 ? self : other
		end
	end

	# def call(obj, method_name, args = [])
	# 	m = find_attr(method_name)
	# 	if m && AdventCore.class_for_val(m) == BLOCK
	# 		m.call(obj, *args)
	# 	else
	# 		# TODO: raise if it's not a method
	# 		ADVENT_REFERENCE_E.raise("Undefined method `#{method_name}' for type `#@name'.")
	# 	end
	# end

	def find_attr(name)
		a = @attributes[name]
		return a if a
		@subclass ? @subclass.find_attr(name) : NONE
	end

	def add_method(name, &block)
		b = Block.new(block, [[:this_isnt_even_used, :self]], true)
		@attributes[name] = AdventValue.new(b, BLOCK)
	end

end

ANY = AdventClass.new(:Any)
NUMBER = AdventClass.new(:Number, ANY)
INTEGER = AdventClass.new(:Integer, NUMBER)
FLOAT = AdventClass.new(:Float, NUMBER)
STRING = AdventClass.new(:String, ANY)
BLOCK = AdventClass.new(:Block, ANY)
NULL = AdventClass.new(:Null, ANY)
BOOLEAN = AdventClass.new(:Boolean, ANY)

# yes, I meant to type "slef"
ANY.add_method(:toString) { |slef| AdventValue.new("<#{slef.klass.name}>", STRING) }
NUMBER.add_method(:toString) { |slef| AdventValue.new(slef.rb_val.to_s, STRING) }
STRING.add_method(:toString) { |slef| AdventValue.new(slef.rb_val.inspect, STRING) }
BLOCK.add_method(:toString) do |slef|
	ps = slef.rb_val.params.map(&:first).join(", ")
	str = ": #{ps}"
	AdventValue.new("<Block#{ps.empty? ? '' : str}>", STRING)
end
BOOLEAN.add_method(:toString) { |slef| AdventValue.new(slef.rb_val.to_s, STRING) }
NULL.add_method(:toString) { |slef| AdventValue.new("null", STRING) }

# special values, not for use in Advent, only in the source
NONE = AdventClass.new(:None, nil, false)
EXIT = AdventClass.new(:Exit, nil, false)

