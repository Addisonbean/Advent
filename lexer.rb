#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "lexer.rex".
#++

require 'racc/parser'
class MyLangParser < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/[ \t]+/))
        ;

      when (text = @ss.scan(/[a-zA-Z_]\w*/))
         action { [:VAR, text.to_sym] }

      when (text = @ss.scan(/\d+/))
         action { [:NUMBER, text.to_i] }

      when (text = @ss.scan(/\*/))
         action { [:MULTIPLY, text.to_sym] }

      when (text = @ss.scan(/\//))
         action { [:DIVIDE, text.to_sym] }

      when (text = @ss.scan(/\+/))
         action { [:ADD, text.to_sym] }

      when (text = @ss.scan(/\-/))
         action { [:SUBTRACT, text.to_sym] }

      when (text = @ss.scan(/=/))
         action { [:EQUALS, text.to_sym] }

      when (text = @ss.scan(/\(/))
         action { [:LEFT_PARENTHESIS, text.to_sym] }

      when (text = @ss.scan(/\)/))
         action { [:RIGHT_PARENTHESIS, text.to_sym] }

      when (text = @ss.scan(/("([^"]|\\")*?(?<!\\)")|('([^']|\\')*?(?<!\\)')/))
         action { [:STRING, text] }

      when (text = @ss.scan(/{/))
         action { [:CURLY_BRACKET_L, text.to_sym] }

      when (text = @ss.scan(/}/))
         action { [:CURLY_BRACKET_R, text.to_sym] }

      when (text = @ss.scan(/(\n|;)/))
         action { [:NEW_LINE, nil] }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

	def tokenize(code)
		scan_setup(code)
		tokens = []
		while token = next_token
			tokens << token
		end
		tokens
	end
end # class

