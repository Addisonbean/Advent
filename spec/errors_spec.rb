require_relative "../lib/advent_core"
require_relative "../lib/advent_errors"
require "minitest/autorun"

describe Advent do

	before do
		@err = ""
		@lang = Advent.new
		AdventError.options[:error_output] = @err
	end

	describe "reference errors" do
		it "happens when necessary" do
			-> { @lang.exec("doesnt_exist + 5") }.must_raise SystemExit
			@err.must_include "Reference Error"
		end

		it "doesn't happen when not necessary" do
			@lang.exec("a = 4; b = 7; a + b")
			@err.must_equal ""
		end
	end

	describe "operator conflict errors" do
		it "happens when necessary" do
			-> { @lang.exec(<<CODE) }.must_raise SystemExit
op + { x: Integer, y: Number in 
	x * y - 1
}
op + { x: Number, y: Integer in 
	x * y - 1
}
4 + 5
CODE
			@err.must_include "Operator Conflict"
		end

		it "doesn't happen when not necessary" do
			@lang.exec(<<CODE).rb_val.must_equal 9.0
op + { x: Integer, y: Number in 
	x * y - 1
}
op + { x: Number, y: Integer in 
	x * y - 1
}
4.0 + 5.0
CODE
			@err.must_equal ""
		end
	end

	describe "argument errors" do
		it "happens when necessary" do
			-> { @lang.exec(%("str" + 4)) }.must_raise SystemExit
			@err.must_include "Argument Error"
		end
	end

end

