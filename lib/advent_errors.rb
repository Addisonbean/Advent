require_relative "advent_errors"

class AdventError

	@@options = {
		error_output: $stderr,
		exit_on_error: true
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
		exit exit_status if @@options[:exit_on_error]
		return EXIT
	end

end

ADVENT_ARGUMENT_E = AdventError.new("Argument")
ADVENT_OP_CONFLICT_E = AdventError.new("Operator Conflict")
ADVENT_PARSE_E = AdventError.new("Parse")
ADVENT_REFERENCE_E = AdventError.new("Reference")

