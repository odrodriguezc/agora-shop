require 'rails_helper'
RSpec.describe Importing::Transforms::ValidateBasic do
  subject(:transform) { described_class.new }

  describe '#call' do
    let(:valid_row) { { title: "Widget", price: "10.5", stock_quantity: "2" } }

    it 'returns the row when all fields are valid' do
      expect(transform.call(valid_row)).to eq(valid_row)
      expect(transform.instance_variable_get(:@errors)).to be_empty
    end

    it 'rejects rows with blank title' do
      row = valid_row.merge(title: "  ")
      result = transform.call(row)
      expect(result).to be_nil
      errors = transform.instance_variable_get(:@errors)
      expect(errors.size).to eq(1)
      expect(errors.first[:field]).to eq(:title)
      expect(errors.first[:message]).to include("must be a non-empty string")
    end

    it 'rejects rows with non-numeric price' do
      row = valid_row.merge(price: "not_a_number")
      transform.call(row)
      errors = transform.instance_variable_get(:@errors)
      expect(errors.size).to eq(1)
      expect(errors.first[:field]).to eq(:price)
      expect(errors.first[:message]).to include("must be a positive number or zero")
    end

    it 'rejects rows with negative stock_quantity' do
      row = valid_row.merge(stock_quantity: -1)
      transform.call(row)
      errors = transform.instance_variable_get(:@errors)
      expect(errors.size).to eq(1)
      expect(errors.first[:field]).to eq(:stock_quantity)
      expect(errors.first[:message]).to include("must be a positive number or zero")
    end

    it 'stops at the first validation error' do
      row = { title: "", price: "not_a_number", stock_quantity: -5 }
      transform.call(row)
      errors = transform.instance_variable_get(:@errors)
      expect(errors.map { |e| e[:field] }).to eq([ :title ])
    end

    it 'accepts zero for numeric fields' do
      row = { title: "A", price: 0, stock_quantity: "0" }
      expect(transform.call(row)).to eq(row)
      expect(transform.instance_variable_get(:@errors)).to be_empty
    end
  end

  describe '#finish' do
    it 'logs a warning when there are errors' do
      transform.call({ title: nil, price: 1, stock_quantity: 1 })
      expect(Rails.logger).to receive(:warn).with(/Dropped 1 rows: /)
      transform.finish
    end

    it 'does not log when there are no errors' do
      expect(Rails.logger).not_to receive(:warn)
      described_class.new.finish
    end
  end
end
