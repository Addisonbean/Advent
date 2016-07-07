class LangClass

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

ANY = LangClass.new(:Any)
NUMBER = LangClass.new(:Number, ANY)
INTEGER = LangClass.new(:Integer, NUMBER)
FLOAT = LangClass.new(:Float, NUMBER)
STRING = LangClass.new(:String, ANY)
BLOCK = LangClass.new(:Block, ANY)
NULL = LangClass.new(:Null, ANY)
BOOLEAN = LangClass.new(:Boolean, ANY)

# special value, not for use in MyLang, only in the source
NONE = LangClass.new(:None)

