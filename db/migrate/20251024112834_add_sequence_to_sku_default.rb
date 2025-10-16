class AddSequenceToSkuDefault < ActiveRecord::Migration[8.0]
  DEFAULT_SKU_EXPRESSION = "'SKU' || LPAD(nextval('product_sku_seq')::text, 8, '0')"
  def up
    change_column_default :products, :sku, from: nil, to: -> { DEFAULT_SKU_EXPRESSION }
  end

  def down
    change_column_default :products, :sku, from: -> { DEFAULT_SKU_EXPRESSION }, to: nil
  end
end
