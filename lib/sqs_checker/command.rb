# frozen_string_literal: true

require 'json'

module SqsChecker
  class Command # :nodoc:
    # @param [Array<String>] argv
    #
    # @return [void]
    def start(argv)
      action = argv[0]
      return show_usage unless action

      case action
      when 'list'
        execute_list(argv[1..])
      when 'delete'
        execute_delete(argv[1..])
      else
        raise "Invalid action `#{action}`"
      end
    end

    private

    # @return [Pathname]
    def base_dir
      Pathname.new(Dir.pwd)
    end

    # @return [Hash{Symbol, String => String}] credentials
    def credentials
      @credentials ||= ::JSON.parse(::File.read(base_dir.join('credentials.json')))
    end

    # @return [void]
    def show_usage
      puts 'Usage: sqs_checker [list/delete] [queue_name] ...[other options]'
    end

    # @param [Array<String>] argv
    #
    # @return [void]
    def execute_list(argv)
      queue_name, = argv
      return show_list_usage unless queue_name

      puts '[Start] listing'
      require 'sqs_checker/event_type_fetcher'
      EventTypeFetcher.new(credentials: credentials, queue_name: queue_name).fetch
      puts '[End] listing'
    end

    # @return [void]
    def show_list_usage
      puts 'Usage: sqs_checker list [queue_name]'
    end

    # @param [Array<String>] argv
    #
    # @return [void]
    def execute_delete(argv)
      queue_name, type_name, = argv
      return show_delete_usage unless type_name

      puts '[Start] Delete'
      require 'sqs_checker/event_deleter'
      EventDeleter.
        new(credentials: credentials, queue_name: queue_name, type_name: type_name).
        execute!
      puts '[End] Delete'
    end

    # @return [void]
    def show_delete_usage
      puts 'Usage: sqs_checker list [queue_name] [target_event_type]'
    end
  end
end
