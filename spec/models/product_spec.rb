require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "factories" do
    it "builds a valid product" do
      product = build(:product)

      expect(product).to be_valid
    end
  end

  describe "validations" do
    it "requires a title" do
      product = build(:product, title: nil)

      expect(product).not_to be_valid
      expect(product.errors.added?(:title, :blank)).to be(true)
    end

    it "limits the title length to 255 characters" do
      product = build(:product, title: "a" * 256)

      expect(product).not_to be_valid
      expect(product.errors.added?(:title, :too_long, count: 255)).to be(true)
    end

    it "rejects a negative price" do
      product = build(:product, price: -0.01)

      expect(product).not_to be_valid
      expect(product.errors.added?(:price, :greater_than_or_equal_to, value: -0.01, count: 0)).to be(true)
    end

    it "rejects a non-numeric price" do
      product = build(:product, price: "not-a-number")

      expect(product).not_to be_valid
      expect(product.errors.added?(:price, :not_a_number, value: 'not-a-number')).to be(true)
    end

    it "rejects a negative stock quantity" do
      product = build(:product, stock_quantity: -1)

      expect(product).not_to be_valid
      expect(product.errors.added?(:stock_quantity, :greater_than_or_equal_to, value: -1, count: 0)).to be(true)
    end

    it "rejects a non-integer stock quantity" do
      product = build(:product, stock_quantity: 2.5)

      expect(product).not_to be_valid
      expect(product.errors.added?(:stock_quantity, :not_an_integer, value: 2.5)).to be(true)
    end

    it "requires a SKU" do
      product = build(:product, sku: nil)

      expect(product).not_to be_valid
      expect(product.errors.added?(:sku, :blank)).to be(true)
    end

    it "enforces SKU uniqueness" do
      existing_product = create(:product)
      product = build(:product, sku: existing_product.sku)

      expect(product).not_to be_valid
      expect(product.errors.of_kind?(:sku, :taken)).to be(true)
    end

    it "enforces SKU format" do
      product = build(:product, sku: "BADSKU")

      expect(product).not_to be_valid
      expect(product.errors.added?(:sku, :invalid, value: "BADSKU")).to be(true)
    end
  end

  describe "associations" do
    it "belongs to a category" do
      category = create(:category)
      product = build(:product, category: category)

      expect(product.category).to eq(category)
    end
  end

  describe "status enum" do
    it "exposes the expected statuses" do
      expect(described_class.statuses.keys).to contain_exactly("draft", "published", "archived")
    end

    it "provides predicate helpers for each status" do
      product = build(:product, status: :draft)

      expect(product.draft?).to be(true)
      product.status = :published
      expect(product.published?).to be(true)
      product.status = :archived
      expect(product.archived?).to be(true)
    end
  end
end
