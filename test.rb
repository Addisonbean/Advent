#!/usr/bin/env ruby

require_relative "my_lang_core"
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

		it "uses parentheses" do
			@lang.exec("(10 + 12) * 3 + 2").must_equal 68
		end

		it "does multi-level parentheses" do
			@lang.exec("(3 - (2 - 1)) * 4").must_equal 8
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
		# @lang.exec("{ a, b in a + b }(5, 4)")
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

	describe "if" do
		it "runs the block for truthy values" do
			@lang.exec(%( if 5 { 4 } )).must_equal 4
			@lang.exec(%(
if 5 {
	4
}
			)).must_equal 4
			@lang.exec(%( if NULL { 7 } )).must_equal nil
		end
	end

end

