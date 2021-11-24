# frozen_string_literal: true

RSpec.describe SqsChecker do # rubocop:disable RSpec/FilePath
  describe '::VERSION' do
    subject(:version) { described_class::VERSION }

    it { is_expected.not_to be_nil }
  end
end
