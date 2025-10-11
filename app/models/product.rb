class Product < ApplicationRecord
  SKU_FORMAT = /\ASKU\d+\z/

  enum :status, { draft: "draft", published: "published", archived: "archived" }

  # Associations
  belongs_to :category, optional: true

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, presence: true, uniqueness: true
  validates :sku, format: { with: SKU_FORMAT, message: "must start with 'SKU' followed by digits" }
end
