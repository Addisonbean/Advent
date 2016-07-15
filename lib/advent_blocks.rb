class Block

	attr_accessor :tree, :params, :scope, :is_rb_block

	def initialize(tree, params = [], is_rb_block = false)
		@tree = tree
		# params: [[:Type, :name], ...]
		# ps: `:Type` may not really exists or be a type
		@params = params
		@scope = nil
		@is_rb_block = is_rb_block
	end

end

