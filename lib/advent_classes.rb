class AdventClass

	attr_accessor :name, :subclass, :superclasses

	CLASS_LIST = {}

	def initialize(name, subclass = nil, add_to_list = true)
		@name = name
		@subclass = subclass
		@subclass.superclasses << self if @subclass
		@superclasses = []
		@attrs = []
		CLASS_LIST[name] = self if add_to_list
	end

	def distance_from(other_class, dist = 0)
		return -1 if !@subclass && other_class.subclass
		other_class == self ? dist : @subclass.distance_from(other_class, dist + 1)
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

	# def find_attr(attr_name)
	# 	m = @attr[attr_name]
	# 	return m if m
	# 	@subclass ? @subclass.find_attr(attr_name) : NONE
	# end

	# def attr(attr_name)
	# 	a = find_attr(attr_name)
	# 	if a == NONE
	# 		ADVENT_REFERENCE_E.raise("Undefined attribute `#{attr_name}` for type `#@name`.")
	# 	else
	# 		a
	# 	end
	# end

end

ANY = AdventClass.new(:Any)
NUMBER = AdventClass.new(:Number, ANY)
INTEGER = AdventClass.new(:Integer, NUMBER)
FLOAT = AdventClass.new(:Float, NUMBER)
STRING = AdventClass.new(:String, ANY)
BLOCK = AdventClass.new(:Block, ANY)
NULL = AdventClass.new(:Null, ANY)
BOOLEAN = AdventClass.new(:Boolean, ANY)

# special values, not for use in Advent, only in the source
NONE = AdventClass.new(:None, nil, false)
EXIT = AdventClass.new(:Exit, nil, false)

