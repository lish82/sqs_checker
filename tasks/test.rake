# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new

namespace :spec do
  desc 'Run spec parallel'
  task :parallel do
    require 'test_queue'
    require 'test_queue/runner/rspec'

    runner = Class.new(TestQueue::Runner::RSpec) do
      def after_fork(num)
        ENV['TEST_ENV_NUMBER'] = num.to_s
      end
    end

    old_argv = ARGV.dup
    begin
      ARGV.clear << 'spec'
      runner.new.execute
    ensure
      ARGV.clear.push(*old_argv)
    end
  end
end

desc 'Generate yard documentation'
task :yard do
  require 'yard'
  YARD::CLI::CommandParser.run
end

namespace :yard do
  desc 'List yard undocumented objects'
  task :list_undoc do
    require 'yard'
    YARD::CLI::CommandParser.run('stats', '--list-undoc')
  end
end
