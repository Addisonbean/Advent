require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |c|
	options = ['--color']
	options += ["--format", "documentation"]
	c.rspec_opts = options
end

desc "Generate Lexer"
task :lexer do
	`rex lexer.rex -o lexer.rb`
end

desc "Generate Parser"
task :parser do
	`racc parser.y -o parser.rb`
end

desc "Tests things"
task :spec do
	`./spec/all_spec.rb`
end

desc "Generate Lexer and Parser"
task :generate => [:lexer, :parser]

desc "Generate Lexer and Parser and Run Tests"
task :test => [:generate, :spec]
