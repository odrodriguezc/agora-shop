FactoryBot.define do
  factory :product do
    title { "Sample Product" }
    description { "This is a sample product description." }
    price { 9.99 }
    stock_quantity { 100 }
    status { "draft" }
    sequence(:sku) { |n| format("SKU%08d", n) }
  end

  factory :draft_product, parent: :product do
    status { "draft" }
  end

  factory :published_product, parent: :product do
    status { "published" }
  end

  factory :archived_product, parent: :product do
    status { "archived" }
  end
end
