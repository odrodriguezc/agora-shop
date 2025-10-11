require 'rails_helper'

RSpec.describe "PATCH /products/:id", type: :request do
  let(:existing_product) { create(:product, category_id: nil) }
  let(:valid_params) { { product: { title: "Updated Product Title", price: 19.99 } } }
  let(:invalid_params) { { product: { title: "", price: -5 } } }
  let(:updated_product) { Product.find(existing_product.id) }
  let(:perform_request) { -> { patch product_url(existing_product, format: request_format), params: valid_params } }
  let(:category) { create(:category) }

  context "when the request format is HTML" do
    let(:request_format) { :html }

    context "when the user is unauthenticated" do
      include_context "as unauthenticated user"
      it_behaves_like "requires authentication"
    end

    context "when the user is a guest user" do
      include_context "as guest user"
      it_behaves_like "denies access with authorization alert"
    end

    context "when the user is an admin" do
      include_context "as admin user"

      context "with valid parameters" do
        it_behaves_like "updates product successfully", format: :html
        it_behaves_like "updates product category successfully", format: :html
      end

      context "with invalid parameters" do
        it_behaves_like "rejects invalid product update", format: :html
      end
    end
  end

  context "when the request format is JSON" do
    let(:request_format) { :json }

    context "when the user is unauthenticated" do
      include_context "as unauthenticated user"
      it_behaves_like "requires authentication"
    end

    context "when the user is a guest user" do
      include_context "as guest user"
      it_behaves_like "denies access with JSON response"
    end

    context "when the user is an admin" do
      include_context "as admin user"

      context "with valid parameters" do
        it_behaves_like "updates product successfully", format: :json
      end

      context "with invalid parameters" do
        it_behaves_like "rejects invalid product update", format: :json
      end
    end
  end
end
