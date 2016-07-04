#!/usr/bin/env ruby

require_relative "parser"

l = MyLangParser.new
p l.parse("a = 9; b = 10")
p l.parse("a + b")

