class Product < ApplicationRecord
  enum :status, { draft: "draft", published: "published", archived: "archived" }

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, presence: true, uniqueness: true
end
