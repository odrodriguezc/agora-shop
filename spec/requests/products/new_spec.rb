require 'rails_helper'
RSpec.describe "GET /products/new", type: :request do
  let(:perform_request) { -> { get new_product_url(format: request_format) } }

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

      it "renders the new product form" do
        perform_request.call
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # TODO: Implement JSON request tests
  context "when the request format is JSON" do
  end
end
