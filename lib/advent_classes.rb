class AdventClass

	attr_accessor :name, :subclass, :superclasses

	CLASS_LIST = {}

	def initialize(name, subclass = nil)
		@name = name
		@subclass = subclass
		@subclass.superclasses << self if @subclass
		@superclasses = []
		CLASS_LIST[name] = self
	end

	# def distance_from(other_class, originals = nil, dist = 0, reverse = false)
	# 	originals = [self, other_class] if originals.nil?
	# 	# return -1 if !@subclass && other_class.subclass
	# 	if !@subclass && other_class.subclass
	# 		return reverse ? -1 : originals[1].distance_from(originals[0], nil, 0, true)
	# 	end
	# 	other_class == self ? dist : @subclass.distance_from(other_class, originals, dist + 1, reverse)
	# end

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

# special value, not for use in MyAdvent, only in the source
NONE = AdventClass.new(:None)

