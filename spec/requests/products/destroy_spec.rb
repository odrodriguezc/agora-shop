require 'rails_helper'

RSpec.describe "DELETE /products/:id", type: :request do
  let(:product) { create(:product) }
  let(:perform_request) { -> { delete product_url(product) } }
  context "when the format is HTML" do
    before { product } # Ensure the product is created before each test
    context "when the user is unauthenticated" do
      include_context "as unauthenticated user"

      it_behaves_like "requires authentication"
    end

    context "when the user is authenticated as guest user" do
      include_context "as guest user"
      it_behaves_like "denies access with authorization alert"
    end

    context "when the user is authenticated as admin user" do
      include_context "as admin user"

      it "deletes the specified product" do
        expect {
          perform_request.call
        }.to change(Product, :count).by(-1)
      end

      it "redirects to products" do
        perform_request.call

        expect(response).to redirect_to(products_url)
      end
    end
  end
end
