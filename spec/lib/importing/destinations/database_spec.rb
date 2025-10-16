require 'rails_helper'
RSpec.describe Importing::Destinations::Database do
  it_behaves_like 'a importing destination base'

  describe '#write' do
    let(:model_class) do
      Class.new(ApplicationRecord) do
        self.abstract_class = true
        const_set(:PERMITTED_ATTRIBUTES, %i[name age email])
      end
    end

    let(:destination) { described_class.new(model: model_class) }

    it 'buffers only permitted attributes and flushes them' do
      row = { name: 'Alice', age: 30, email: 'alice@example.com', password: 'secret' }
      destination.write(row)

      expect(model_class).to receive(:upsert_all).with(
        [{ name: 'Alice', age: 30, email: 'alice@example.com' }]
      )

      destination.flush
    end
  end
end
