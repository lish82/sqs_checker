# frozen_string_literal: true

require 'sqs_checker/sqs_helper'

module SqsChecker
  class EventTypeFetcher # :nodoc:
    # @param [String] queue_name
    def initialize(queue_name:)
      @sqs_helper = SqsHelper.new(queue_name: queue_name)
    end

    # @return [void]
    def fetch
      @sqs_helper.build_default_sqs_poller.poll do |msg|
        data = @sqs_helper.parse_queue_data(msg)
        puts data['type']
      end
    end
  end
end
