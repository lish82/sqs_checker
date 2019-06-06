# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'
require 'bootsnap'

Bootsnap.setup(cache_dir: File.expand_path('../tmp/cache', __dir__))
