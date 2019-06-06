# frozen_string_literal: true

require 'find'
require_relative 'lib/sqs_checker/version'

Gem::Specification.new do |spec|
  spec.name          = 'sqs_checker'
  spec.version       = SqsChecker::VERSION
  spec.authors       = ['lish82']
  spec.email         = %w[h.katagiri.0358@gmail.com]

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['yard.run'] = 'yri'

  # Specify which files should be added to the gem when it is released.
  spec.files = yield_self do
    prunes = %w[. bin doc coverage pkg spec tmp Rakefile]
    files = Find.find(__dir__).map do |full_path|
      next unless (path = full_path[__dir__.length + 1..])

      Find.prune if path.start_with?(*prunes)

      stat = File.lstat(path)
      next unless stat.file? || stat.symlink?

      path
    end
    files.compact - %w[config/boot.rb]
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/[^.]}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'aws-sdk-sqs'

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bootsnap'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'test-queue'
  spec.add_development_dependency 'yard'
end
