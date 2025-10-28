class ProductSearch < ApplicationQuery
  def initialize(relation = Product.all)
    @relation = relation
  end

  def max_by_sku
    having_sku.maximum(Arel.sql("regexp_replace(sku, 'SKU', '')"))
  end

  def having_sku
    @relation.where.not(sku: nil)
  end

  def all
    @relation
  end
end
