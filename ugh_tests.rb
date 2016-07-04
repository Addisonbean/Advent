#!/usr/bin/env ruby

require_relative "parser"

l = MyLangParser.new
p l.tokenize(" if 5 { 4 } ")
p l.tokenize("null")
# p l.parse("a = 9; b = 10")
# p l.parse("a + b")
# p l.parse("a = \n 3")

