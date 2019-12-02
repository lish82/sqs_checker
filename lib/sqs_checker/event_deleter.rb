# frozen_string_literal: true

require 'sqs_checker/sqs_helper'

module SqsChecker
  class EventDeleter # :nodoc:
    # @param [Hash{String => String}] config
    # @param [String] queue_name
    def initialize(config:, queue_name:, type_name:)
      @sqs_helper = SqsHelper.new(config: config, queue_name: queue_name)
      @type_name = type_name
    end

    # @return [void]
    def execute!
      @sqs_helper.build_default_sqs_poller.poll do |msg|
        data = @sqs_helper.parse_queue_data(msg)
        next if @type_name != data['type']

        puts "Delete message (id: #{data['id']}, type: #{data['type']})"
        delete_message!(msg)
      end
    end

    private

    # @param [Aws::SQS::Types::Message] msg
    # @return [void]
    def delete_message!(msg)
      @sqs_helper.sqs_client.delete_message(
        queue_url: @sqs_helper.queue_url,
        receipt_handle: msg.receipt_handle,
      )
    end
  end
end
