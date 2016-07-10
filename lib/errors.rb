class LangError

	@@options = {
		error_output: $stderr
	}

	def self.options
		@@options
	end

	def initialize(type, default_exit_status = 1)
		@type = type
		@default_exit_status = default_exit_status
	end

	def raise(message, exit_status = nil)
		exit_status ||= @default_exit_status
		@@options[:error_output] << "#@type Error: #{message}\n"
		exit exit_status
	end

end

LANG_ARGUMENT_E = LangError.new("Argument")
LANG_OP_CONFLICT_E = LangError.new("Operator Conflict")
LANG_PARSE_E = LangError.new("Parse")
LANG_REFERENCE_E = LangError.new("Reference")

