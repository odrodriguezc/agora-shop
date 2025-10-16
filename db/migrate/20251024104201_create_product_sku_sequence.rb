class CreateProductSkuSequence < ActiveRecord::Migration[8.0]
  def up
    max_sku = select_value(<<-SQL
      SELECT COALESCE(MAX((regexp_replace(sku,'^SKU',''))::bigint), 0) + 1 FROM products;
    SQL
    )

    execute <<-SQL
      CREATE SEQUENCE IF NOT EXISTS product_sku_seq START #{max_sku} AS bigint OWNED BY products.sku;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE IF EXISTS product_sku_seq;
    SQL
  end
end
