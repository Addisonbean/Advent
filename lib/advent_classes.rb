class AdventClass

	attr_accessor :name, :subclass, :superclasses

	CLASS_LIST = {}

	def initialize(name, subclass = nil, add_to_list = true)
		@name = name
		@subclass = subclass
		@subclass.superclasses << self if @subclass
		@superclasses = []
		CLASS_LIST[name] = self if add_to_list
	end

	def distance_from(other_class, dist = 0)
		return -1 if !@subclass && other_class.subclass
		other_class == self ? dist : @subclass.distance_from(other_class, dist + 1)
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

# special values, not for use in Advent, only in the source
NONE = AdventClass.new(:None, nil, false)
EXIT = AdventClass.new(:Exit, nil, false)

