#!/usr/bin/env ruby

require_relative "../my_lang_core"
require "minitest/autorun"

# check for errors once they exist
describe MyLang do

	before do
		@lang = MyLang.new
	end

	describe "variables" do
		it "assigns usable variables" do
			@lang.exec("a = 4")
			@lang.exec("a").must_equal 4
		end

		it "does complex assignments" do
			@lang.exec("a = (4 + 8) * 2")
			@lang.exec("b = 2 * (c = a + 1) + 1")
			@lang.exec("a").must_equal 24
			@lang.exec("b").must_equal 51
			@lang.exec("c").must_equal 25
		end

		it "allows cool variable names" do
			@lang.exec("_123 = 74")
			@lang.exec("_123").must_equal 74
		end
	end

	describe "PEMDAS" do
		it "does math" do
			@lang.exec("10 + 12 * 3 + 2").must_equal 48 
		end

		it "does simple parentheses" do
			@lang.exec("(1)").must_equal 1
		end
		
		it "has floats" do
			@lang.exec("1.23").must_equal 1.23
		end

		it "does float math" do
			@lang.exec("1 + 4.5").must_equal 5.5
			@lang.exec("5.0 / 2").must_equal 2.5
		end

		it "does integer math" do
			@lang.exec("5 / 2").must_equal 2
		end

		it "uses parentheses" do
			@lang.exec("(10 + 12) * 3 + 2").must_equal 68
		end

		it "does multi-level parentheses" do
			@lang.exec("(3 - (2 - 1)) * 4").must_equal 8
		end

		it "does powers" do
			@lang.exec("(3 - (2 - 1)) ** 2 ** 3 * 4").must_equal 1024
		end

		it "uses a left associative subtraction" do
			@lang.exec("3 - 2 - 1").must_equal 0
		end

		it "uses a unary minus sign" do # reword this?
			@lang.exec("-3").must_equal -3
			@lang.exec("9 + -4 * -(3)").must_equal 21
			@lang.exec("(9 + -4) * -(3)").must_equal -15
		end
	end

	describe "strings" do
		it "parses strings" do
			@lang.exec(%{'hello world.'}).must_equal "hello world."
			@lang.exec(%{"hello world."}).must_equal "hello world."
			@lang.exec(%{''}).must_equal ""
		end

		it "assigns strings" do
			@lang.exec("a = 'hey'")
			@lang.exec("a").must_equal "hey"
		end

		# TODO: fix
		# it "handles escape charectors" do
		# 	@lang.exec(%{"hey\\"\\n"}).must_equal "hey\"\n"
		# end
		
		it "adds strings" do
			@lang.exec(%{"Hello, " + "world" + "!"}).must_equal "Hello, world!"
		end

		it "multiplies strings" do
			@lang.exec(%{"1" * 3}).must_equal "111"
		end

		it "adds and multiplies" do
			@lang.exec(%{("Na" + "N ") * 3 + "!"}).must_equal "NaN NaN NaN !"
		end

		it "handles string with strange charecters" do
			@lang.exec(%{"(( Hey {} !"}).must_equal "(( Hey {} !"
		end
	end

	# this is what I need to implement
	describe "blocks" do
		it "returns the right value" do
			@lang.exec("a = 4")
			@lang.exec("b = 5")
			@lang.exec("{ a + b }()").must_equal 9
		end

		it "handles multiline blocks" do
			@lang.exec("a = 3")
			@lang.exec("b = 7")
			@lang.exec(%<{
	a * b;
}()>).must_equal 21
		end

		it "calls blocks with arguments" do
			@lang.exec("{ v1, v2 in v2 * (v1 - 1) }(9, 10)").must_equal 80
		end

		it "uses the parent scope" do
			@lang.exec("a = 2; { v1, v2 in v2 * (v1 - a) }(9, 10)").must_equal 70
			@lang.exec("a = 2; { a = 4 }(); a").must_equal 4
		end

		it "uses it's own scope" do
			@lang.exec("a = 2; { a in a + 20 }(5)").must_equal 25
		end

		it "preserves the parent scope" do
			@lang.exec("a = 2; { a in a = 4 }(5); a").must_equal 2
			@lang.exec("a = 2; { a in a }(5); a").must_equal 2
		end
	end

	describe "booleans" do
		it "works?" do
			@lang.exec("true").must_equal true
			@lang.exec("false").must_equal false
			@lang.exec("null").must_equal nil
		end
	end

	describe "boolean logic" do
		it "does equalities" do
			@lang.exec("1 == 1").must_equal true
			@lang.exec("1 != 1").must_equal false
			@lang.exec("1 == 3").must_equal false
			@lang.exec("1 != 3").must_equal true
			@lang.exec(%{'a' == 'a'}).must_equal true
			@lang.exec(%{'a' != 'a'}).must_equal false
			@lang.exec(%{'a' == 'b'}).must_equal false
			@lang.exec(%{'a' != 'b'}).must_equal true
		end

		it "does inequalities" do
			@lang.exec("1 > 1").must_equal false
			@lang.exec("1 >= 1").must_equal true
			@lang.exec("1 > 3").must_equal false
			@lang.exec("1 >= 3").must_equal false
			@lang.exec("3 > 1").must_equal true
			@lang.exec("3 >= 1").must_equal true
		end

		it "inverts truthy-ness" do
			@lang.exec("!1").must_equal false
			@lang.exec("!0").must_equal false
			@lang.exec("!'a'").must_equal false
			@lang.exec("!''").must_equal false
			@lang.exec("!true").must_equal false
			@lang.exec("!false").must_equal true
			@lang.exec("!null").must_equal true
		end
	end

	describe "new lines and semicolons" do
		it "allows semicolons to break up lines" do
			@lang.exec("a = 9; b = 10")
			# @lang.exec("a + b").must_equal 19
			@lang.exec("a").must_equal 9
			@lang.exec("b").must_equal 10
		end

		it "allows newlines (\\n) to break up lines" do
			@lang.exec("a = 9\n b = 10")
			# @lang.exec("a + b").must_equal 19
			@lang.exec("a").must_equal 9
			@lang.exec("b").must_equal 10
		end
	end

	describe "if statements" do
		it "runs the block for truthy values" do
			@lang.exec(%( if 5 { 4 } )).must_equal 4
			@lang.exec(%(
if 5 {
	4
}
			)).must_equal 4
			@lang.exec(%( if NULL { 7 } )).must_equal nil
		end

		it "executes the 'else' block if the condition is fasly" do
			@lang.exec(%( if null { 4 } else { 3 } )).must_equal 3
			@lang.exec(%( if 5 { 4 } else { 3 } )).must_equal 4
		end
	end

end

