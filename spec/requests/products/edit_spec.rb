require 'rails_helper'

RSpec.describe "GET /products/:id/edit", type: :request do
  let(:created_product) { create(:product) }
  let(:perform_request) { -> { get edit_product_url(created_product, format: request_format) } }
  context "when the format is HTML" do
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

      it "allows access to the edit page" do
        perform_request.call
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end
  end

  # TODO: Complete test
  context "when the format is JSON" do
  end
end
