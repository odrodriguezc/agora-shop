require 'rails_helper'
require_relative '../../../db/migrate/20251024104201_create_product_sku_sequence'


RSpec.describe CreateProductSkuSequence, type: :migration do
  let(:migration) { described_class.new }
  let(:connection) { ActiveRecord::Base.connection }

  before do
    connection.execute("DROP SEQUENCE IF EXISTS product_sku_seq;")
    connection.execute("DELETE FROM products;")
  end

  describe '#up' do
    it 'creates the sequence starting from 1 when no products exist' do
      migration.up
      result = connection.select_value("SELECT nextval('product_sku_seq');")
      expect(result).to eq(1)
    end

    it 'creates the sequence starting from max SKU + 1 when products exist' do
      connection.execute("INSERT INTO products (sku, title, created_at, updated_at) VALUES ('SKU100', 'Test Product', NOW(), NOW());")
      migration.up
      result = connection.select_value("SELECT nextval('product_sku_seq');")
      expect(result).to eq(101)
    end
  end

  describe '#down' do
    it 'drops the sequence if it exists' do
      migration.up
      migration.down
      sequences = connection.select_values("SELECT sequence_name FROM information_schema.sequences WHERE sequence_name = 'product_sku_seq';")
      expect(sequences).to be_empty
    end
  end
end
