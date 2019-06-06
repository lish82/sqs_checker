# frozen_string_literal: true

RSpec.describe SqsChecker do
  describe '::VERSION' do
    subject(:version) { described_class::VERSION }

    it { is_expected.not_to be_nil }
  end
end
