require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "factories" do
    it "builds a valid category" do
      category = build(:category)

      expect(category).to be_valid
    end
  end

  describe "validations" do
    it "requires a name" do
      category = build(:category, name: nil)

      expect(category).not_to be_valid
      expect(category.errors.added?(:name, :blank)).to be(true)
    end

    it "limits the name length to 100 characters" do
      category = build(:category, name: "a" * 101)

      expect(category).not_to be_valid
      expect(category.errors.added?(:name, :too_long, count: 100)).to be(true)
    end

    it "requires a unique name" do
      create(:category, name: "UniqueName")
      category = build(:category, name: "UniqueName")

      expect(category).not_to be_valid
      expect(category.errors.added?(:name, :taken, value: "UniqueName")).to be(true)
    end
  end
end
