# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'sqs_checker/core_ext'

module SqsChecker
  class SqsHelper # :nodoc:
    WAIT_TIME_SECONDS = 5 # :nodoc:
    IDLE_TIMEOUT = 5 # :nodoc:

    using CoreExt

    # @param [Hash{Symbol, String => String}] credentials
    # @param [String] queue_name
    #
    # @raise [RuntimeError]
    def initialize(credentials:, queue_name:)
      if queue_name.match?(/production/i)
        raise "Danger!! queue_name `#{queue_name}` includes substring `Production`"
      end

      @credentials = credentials
      @queue_name = queue_name
    end

    def aws_credentials
      @aws_credentials ||= @credentials['session_token'] ? sts_credentials : normal_credentials
    end

    def normal_credentials
      ::Aws::Credentials.new(
        access_key_id: @credentials.fetch('access_key_id'),
        secret_access_key: @credentials.fetch('secret_access_key'),
      )
    end

    def sts_credentials
      ::Aws::AssumeRoleCredentials.new(
        client: ::Aws::STS::Client.new(
          access_key_id: @credentials.fetch('access_key_id'),
          secret_access_key: @credentials.fetch('secret_access_key'),
          session_token: @credentials.fetch('session_token'),
        ),
        role_arn: @credentials.fetch('role_arn'),
        role_session_name: 'sqs_checker',
      )
    end

    # @return [Aws::SQS::Client]
    def sqs_client
      @sqs_client ||= ::Aws::SQS::Client.new(
        credentials: aws_credentials,
        region: @credentials.fetch('region'),
      )
    end

    # @return [String]
    def queue_url
      @queue_url ||= sqs_client.get_queue_url(queue_name: @queue_name).queue_url
    end

    # @return [Aws::SQS::QueuePoller]
    def build_default_sqs_poller
      build_sqs_poller(
        skip_delete: true,
        wait_time_seconds: WAIT_TIME_SECONDS,
        idle_timeout: IDLE_TIMEOUT,
      )
    end

    # @return [Aws::SQS::QueuePoller]
    def build_sqs_poller(params)
      ::Aws::SQS::QueuePoller.new(
        queue_url,
        params.reverse_merge(client: sqs_client),
      )
    end

    # @param [Aws::SQS::Types::Message] message
    #
    # @return [Object]
    def parse_queue_data(message)
      body = ::JSON.parse(message.body)
      ::JSON.parse(body['Message'])
    end
  end
end
