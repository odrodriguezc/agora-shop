class Product < ApplicationRecord
  PERMITTED_ATTRIBUTES = %i[title description price stock_quantity sku category_id].freeze
  SKU_FORMAT = /\ASKU\d+\z/

  enum :status, { draft: "draft", published: "published", archived: "archived" }

  # Associations
  belongs_to :category, optional: true

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: true
  validates :sku, format: { with: SKU_FORMAT, message: "must start with 'SKU' followed by digits", if: -> { sku.present? } }

  # Scopes
  scope :with_numeric_sku, -> { where("sku ~ ?", 'SKU\\d+') }
  scope :with_max_sku_number, -> {
    with_numeric_sku.maximum(Arel.sql("regexp_replace(sku, 'SKU', '')::bigint"))
  }
end
