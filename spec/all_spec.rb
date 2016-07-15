require_relative "../lib/advent_core"
require "minitest/autorun"

# check for errors once they exist
describe Advent do

	before do
		@lang = Advent.new
	end

	describe "variables" do
		it "assigns usable variables" do
			@lang.exec("a = 4")
			@lang.exec("a").rb_val.must_equal 4
		end

		it "does complex assignments" do
			@lang.exec("a = (4 + 8) * 2")
			@lang.exec("b = 2 * (c = a + 1) + 1")
			@lang.exec("a").rb_val.must_equal 24
			@lang.exec("b").rb_val.must_equal 51
			@lang.exec("c").rb_val.must_equal 25
		end

		it "allows cool variable names" do
			@lang.exec("_123 = 74")
			@lang.exec("_123").rb_val.must_equal 74
		end
	end

	describe "PEMDAS" do
		it "does math" do
			@lang.exec("10 + 12 * 3 + 2").rb_val.must_equal 48 
		end

		it "does simple parentheses" do
			@lang.exec("(1)").rb_val.must_equal 1
		end
		
		it "has floats" do
			@lang.exec("1.23").rb_val.must_equal 1.23
		end

		it "does float math" do
			@lang.exec("1 + 4.5").rb_val.must_equal 5.5
			@lang.exec("5.0 / 2").rb_val.must_equal 2.5
		end

		it "does integer math" do
			@lang.exec("5 / 2").rb_val.must_equal 2
		end

		it "uses parentheses" do
			@lang.exec("(10 + 12) * 3 + 2").rb_val.must_equal 68
		end

		it "does multi-level parentheses" do
			@lang.exec("(3 - (2 - 1)) * 4").rb_val.must_equal 8
		end

		it "does powers" do
			@lang.exec("(3 - (2 - 1)) ** 2 ** 3 * 4").rb_val.must_equal 1024
		end

		it "uses a left associative subtraction" do
			@lang.exec("3 - 2 - 1").rb_val.must_equal 0
		end

		it "uses a unary minus sign" do # reword this?
			@lang.exec("-3").rb_val.must_equal -3
			@lang.exec("9 + -4 * -(3)").rb_val.must_equal 21
			@lang.exec("(9 + -4) * -(3)").rb_val.must_equal -15
		end
	end

	describe "strings" do
		it "parses strings" do
			@lang.exec(%{'hello world.'}).rb_val.must_equal "hello world."
			@lang.exec(%{"hello world."}).rb_val.must_equal "hello world."
			@lang.exec(%{''}).rb_val.must_equal ""
		end

		it "assigns strings" do
			@lang.exec("a = 'hey'")
			@lang.exec("a").rb_val.must_equal "hey"
		end

		# TODO: fix
		# it "handles escape charectors" do
		# 	@lang.exec(%{"hey\\"\\n"}).must_equal "hey\"\n"
		# end
		
		it "adds strings" do
			@lang.exec(%{"Hello, " + "world" + "!"}).rb_val.must_equal "Hello, world!"
		end

		it "multiplies strings" do
			@lang.exec(%{"1" * 3}).rb_val.must_equal "111"
		end

		it "adds and multiplies" do
			@lang.exec(%{("Na" + "N ") * 3 + "!"}).rb_val.must_equal "NaN NaN NaN !"
		end

		it "handles string with strange charecters" do
			@lang.exec(%{"(( Hey {} !"}).rb_val.must_equal "(( Hey {} !"
		end
	end

	# this is what I need to implement
	describe "blocks" do
		it "returns the right value" do
			@lang.exec("a = 4")
			@lang.exec("b = 5")
			@lang.exec("{ a + b }()").rb_val.must_equal 9
		end

		it "handles multiline blocks" do
			@lang.exec("a = 3")
			@lang.exec("b = 7")
			@lang.exec(%<{
	a * b;
}()>).rb_val.must_equal 21
		end

		it "calls blocks with arguments" do
			@lang.exec("{ v1, v2 in v2 * (v1 - 1) }(9, 10)").rb_val.must_equal 80
		end

		it "uses the parent scope" do
			@lang.exec("a = 2; { v1, v2 in v2 * (v1 - a) }(9, 10)").rb_val.must_equal 70
			@lang.exec("a = 2; { a = 4 }(); a").rb_val.must_equal 4
		end

		it "uses it's own scope" do
			@lang.exec("a = 2; { a in a + 20 }(5)").rb_val.must_equal 25
		end

		it "preserves the parent scope" do
			@lang.exec("a = 2; { a in a = 4 }(5); a").rb_val.must_equal 2
			@lang.exec("a = 2; { a in a }(5); a").rb_val.must_equal 2
		end

		it "does empty blocks" do
			@lang.exec("a = {}") # won't raise an error
		end
	end

	describe "booleans" do
		it "works?" do
			@lang.exec("true").rb_val.must_equal true
			@lang.exec("false").rb_val.must_equal false
			@lang.exec("null").rb_val.must_equal nil
		end
	end

	describe "boolean logic" do
		it "does equalities" do
			@lang.exec("1 == 1").rb_val.must_equal true
			@lang.exec("1 != 1").rb_val.must_equal false
			@lang.exec("1 == 3").rb_val.must_equal false
			@lang.exec("1 != 3").rb_val.must_equal true
			@lang.exec(%{'a' == 'a'}).rb_val.must_equal true
			@lang.exec(%{'a' != 'a'}).rb_val.must_equal false
			@lang.exec(%{'a' == 'b'}).rb_val.must_equal false
			@lang.exec(%{'a' != 'b'}).rb_val.must_equal true
		end

		it "does inequalities" do
			@lang.exec("1 > 1").rb_val.must_equal false
			@lang.exec("1 >= 1").rb_val.must_equal true
			@lang.exec("1 > 3").rb_val.must_equal false
			@lang.exec("1 >= 3").rb_val.must_equal false
			@lang.exec("3 > 1").rb_val.must_equal true
			@lang.exec("3 >= 1").rb_val.must_equal true
		end

		it "inverts truthy-ness" do
			@lang.exec("!1").rb_val.must_equal false
			@lang.exec("!0").rb_val.must_equal false
			@lang.exec("!'a'").rb_val.must_equal false
			@lang.exec("!''").rb_val.must_equal false
			@lang.exec("!true").rb_val.must_equal false
			@lang.exec("!false").rb_val.must_equal true
			@lang.exec("!null").rb_val.must_equal true
		end
	end

	describe "new lines and semicolons" do
		it "allows semicolons to break up lines" do
			@lang.exec("a = 9; b = 10")
			# @lang.exec("a + b").must_equal 19
			@lang.exec("a").rb_val.must_equal 9
			@lang.exec("b").rb_val.must_equal 10
		end

		it "allows newlines (\\n) to break up lines" do
			@lang.exec("a = 9\n b = 10")
			# @lang.exec("a + b").must_equal 19
			@lang.exec("a").rb_val.must_equal 9
			@lang.exec("b").rb_val.must_equal 10
		end
	end

	describe "if statements" do
		it "runs the block for truthy values" do
			@lang.exec(%( if 5 { 4 } )).rb_val.must_equal 4
			@lang.exec(%(
if 5 {
	4
}
			)).rb_val.must_equal 4
			@lang.exec(%( if null { 7 } )).rb_val.must_equal nil
		end

		it "executes the 'else' block if the condition is fasly" do
			@lang.exec(%( if null { 4 } else { 3 } )).rb_val.must_equal 3
			@lang.exec(%( if 5 { 4 } else { 3 } )).rb_val.must_equal 4
		end
	end

	describe "attributes" do
		it "gets attributes" do
			@lang.exec("4.toString()").rb_val.must_equal "4"
		end

		it "assigns attributes" do
			@lang.exec("a = 43")
			@lang.exec("a.hello = 2020")
			@lang.exec("a.hello").rb_val.must_equal 2020
		end
	end

end

