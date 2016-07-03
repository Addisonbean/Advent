#!/usr/bin/env ruby

require_relative "parser.rb"
require "minitest/autorun"

# check for errors once they exist
describe MyLang do

	before do
		@parser = MyLang.new
	end

	describe "variables" do
		it "assigns usable variables" do
			@parser.parse("a = 4")
			@parser.parse("a").value.must_equal 4
		end

		it "does complex assignments" do
			@parser.parse("a = (4 + 8) * 2")
			@parser.parse("b = 2 * (c = a + 1) + 1")
			@parser.parse("a").value.must_equal 24
			@parser.parse("b").value.must_equal 51
			@parser.parse("c").value.must_equal 25
		end

		it "allows cool variable names" do
			@parser.parse("_123 = 74")
			@parser.parse("_123").value.must_equal 74
		end
	end

	describe "PEMDAS" do
		it "does math" do
			@parser.parse("10 + 12 * 3 + 2").value.must_equal 48 
		end

		it "does simple parentheses" do
			@parser.parse("(1)").value.must_equal 1
		end

		it "uses parentheses" do
			@parser.parse("(10 + 12) * 3 + 2").value.must_equal 68
		end

		it "does multi-level parentheses" do
			@parser.parse("(3 - (2 - 1)) * 4").value.must_equal 8
		end
	end

	describe "strings" do
		it "parses strings" do
			@parser.parse(%{'hello world.'}).value.must_equal "hello world."
			@parser.parse(%{"hello world."}).value.must_equal "hello world."
			@parser.parse(%{''}).value.must_equal ""
		end

		it "assigns strings" do
			@parser.parse("a = 'hey'")
			@parser.parse("a").value.must_equal "hey"
		end

		# TODO: fix
		# it "handles escape charectors" do
		# 	@parser.parse(%{"hey\\"\\n"}).value.must_equal "hey\"\n"
		# end
		
		it "adds strings" do
			@parser.parse(%{"Hello, " + "world" + "!"}).value.must_equal "Hello, world!"
		end

		it "multiplies strings" do
			@parser.parse(%{"1" * 3}).value.must_equal "111"
		end

		it "adds and multiplies" do
			@parser.parse(%{("Na" + "N ") * 3 + "!"}).value.must_equal "NaN NaN NaN !"
		end
	end

end

