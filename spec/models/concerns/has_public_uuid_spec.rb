# frozen_string_literal: true

#
# Shared example: "has public uuid"
#
# Purpose:
# - Ensures a model exposes a RFC 4122-compliant UUID via `uuid` and uses it in `to_param`.
#
# Requirements:
# - The model has a `uuid` column/attribute (String).
# - A callback or default assigns `uuid` on create.
# - `to_param` returns the `uuid` (not the numeric id).
#
# Usage:
#   RSpec.describe Product, type: :model do
#     # Provide the minimal attributes needed to create/validate the record.
#     it_behaves_like "has public uuid", { name: "Sample Product" }
#     # or with FactoryBot:
#     # it_behaves_like "has public uuid", attributes_for(:product)
#   end
#
# Notes:
# - The regex accepts any RFC 4122 UUID (v1–v5). Tighten it if a specific version is required.
# - Prefer a unique index on `uuid` at the DB level for integrity.
# - Keep `options` minimal to avoid unrelated validation noise in tests.
RSpec.shared_examples "has public uuid", type: :model do |options|
  context "when initialized" do
    let(:model_instance) { described_class.new(options) }
    # Initialize a new instance of the model before each test with the parameters provided

    it "responds to uuid" do
      expect(model_instance).to respond_to(:uuid)
    end

    describe "#to_param" do
      it "to_param method returns the uuid" do
        # Ensures resource URLs are UUID-based instead of numeric IDs.
        expect(model_instance.to_param).to eq(model_instance.uuid)
      end
    end
  end

  context "when persisted" do
    let(:saved_instance) { described_class.create!(options) }
    # Uuid not nil
    it "has a uuid" do
      expect(saved_instance.uuid).not_to be_nil
    end
    # Valid Uuid format
    it "generates a valid UUID format" do
      # Accepts any RFC 4122-compliant UUID (v1–v5). Tighten if a specific version is required.
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
      expect(saved_instance.uuid).to match(uuid_regex)
    end
  end
end
