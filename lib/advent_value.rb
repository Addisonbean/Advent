require_relative "advent_errors"

class AdventValue

	attr_accessor :rb_val, :klass, :attributes, :parent

	def initialize(rb_val, klass)
		@rb_val = rb_val
		@klass = klass
		@attributes = {}
		# if it's a property/method, @parent is the object it's a property of
		@parent = nil
	end

	def find_attr(name)
		a = @attributes[name]
		return a if a
		@klass.find_attr(name)
	end

	# DANGEROUS
	def attr(name)
		a = find_attr(name)
		if a == NONE
			return ADVENT_REFERENCE_E.raise("Undefined attribute `#{name}' for type `#{@klass.name}'.")
		else
			a.parent = self
			a
		end
	end

	def set_attr(name, val)
		@attributes[name] = val
		val.parent = self
	end

end


