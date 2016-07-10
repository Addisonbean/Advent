require_relative "../lib/my_lang_core"
require "minitest/autorun"

describe MyLang do

	describe "operator redefinition" do
		it "works" do
			@lang = MyLang.new
			@lang.exec(%(
op + { x: Integer, y: Integer in 
	x * y
}

4 + 9
			)).must_equal 36
		end

		it "doesn't mess with the operator for other types" do
			@lang = MyLang.new
			@lang.exec(%(
op + { x: Integer, y: Integer in 
	x * y
}

"123" + "abc"
			)).must_equal "123abc"
			@lang = MyLang.new
			@lang.exec(%(
op + { x: Integer, y: Integer in 
	x * y
}

1.0 + 3.0
			)).must_equal 4.0
		end
	end

end

