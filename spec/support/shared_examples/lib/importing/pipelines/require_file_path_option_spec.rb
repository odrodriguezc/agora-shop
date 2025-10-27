require 'rails_helper'

RSpec.shared_examples 'require file_path option' do |pipeline_class:, key:|
  context 'when built source without required options' do
    subject(:pipeline) do
      pipeline_class.new(key: key)
    end
    it 'raises an ArgumentError' do
      expect {
        pipeline.build_source
      }.to raise_error(ArgumentError, /requires a non-empty :file_path option/)
    end
  end
end
