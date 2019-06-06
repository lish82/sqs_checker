# frozen_string_literal: true

module SqsChecker
  module CoreExt # :nodoc:
    refine Hash do
      # @param [Hash] other
      #
      # @return [Hash]
      def reverse_merge(other)
        other.merge(self)
      end
    end
  end
end
