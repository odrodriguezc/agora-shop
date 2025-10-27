require 'rails_helper'

RSpec.describe Importing::Destinations::DatabaseUpsert do
  it_behaves_like 'a importing destination base'

  let(:model_class) do
    Class.new(ApplicationRecord) do
      self.abstract_class = true
      const_set(:PERMITTED_ATTRIBUTES, %i[name age email])
    end
  end

  let(:destination) { described_class.new(model: model_class) }

  describe '#write' do
    it 'buffers only permitted attributes and flushes them' do
      row = { name: 'Alice', age: 30, email: 'alice@example.com', password: 'secret' }
      destination.write(row)

      expect(model_class).to receive(:upsert_all).with(
        [ { name: 'Alice', age: 30, email: 'alice@example.com' } ]
      )

      destination.flush
    end
  end

  describe '#write_batch' do
    it 'buffers and flushes a batch of rows with only permitted attributes' do
      rows = [
        { name: 'Alice', age: 30, email: 'alice@example.com', password: 'secret' },
        { name: 'Bob', age: 25, email: 'bob@example.com', password: 'hidden' }
      ]

      expect(model_class).to receive(:upsert_all).with(
        [
          { name: 'Alice', age: 30, email: 'alice@example.com' },
          { name: 'Bob', age: 25, email: 'bob@example.com' }
        ]
      )

      destination.write_batch(rows)
    end
  end

  describe '#flush' do
    it 'does nothing if the buffer is empty' do
      expect(model_class).not_to receive(:upsert_all)
      destination.flush
    end

    it 'flushes the buffer and clears it' do
      row = { name: 'Alice', age: 30, email: 'alice@example.com', password: 'secret' }
      destination.write(row)

      expect(model_class).to receive(:upsert_all).with(
        [ { name: 'Alice', age: 30, email: 'alice@example.com' } ]
      )

      destination.flush
      expect(destination.send(:buffer)).to be_empty
    end
  end
end
