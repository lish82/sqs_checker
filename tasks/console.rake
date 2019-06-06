# frozen_string_literal: true

desc 'Open pry REPL console'
task :console do
  require 'pry'
  Pry.start
end
