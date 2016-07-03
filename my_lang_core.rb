module MyLangCore

	VARIABLES = {}

	def MyLangCore.binary_operator(val1, val2, operator)
		val1 = variables[val1].value if val1.is_a?(Variable)
		val2 = variables[val2].value if val2.is_a?(Variable)

		# TODO: make errors
		Value.operators[[val1.type, val2.type, operator]].call(val1, val2)
	end

	# TODO: check if var already exists
	def MyLangCore.new_variable(name, value)
		var = Variable.new(name, value)
		VARIABLES[name] = var
		value
	end

	def MyLangCore.get_var(name)
		VARIABLES[name].value
	end

	# fix?
	def MyLangCore.str_escape(str)
		str[1..-2]
	end

end

# types: "Number", "String"
class Value

	attr_accessor :value, :type

	@@operators = {
		["Number", "Number", :+] => -> (x, y) { Value.new(x.value + y.value, "Number") },
		["Number", "Number", :-] => -> (x, y) { Value.new(x.value - y.value, "Number") },
		["Number", "Number", :*] => -> (x, y) { Value.new(x.value * y.value, "Number") },
		["Number", "Number", :/] => -> (x, y) { Value.new(x.value / y.value, "Number") },
		["String", "String", :+] => -> (x, y) { Value.new(x.value + y.value, "String") },
		["String", "Number", :*] => -> (x, y) { Value.new(x.value * y.value, "String") }
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

