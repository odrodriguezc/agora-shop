require 'rails_helper'

RSpec.describe "GET /products", type: :request do
  let(:perform_request) { -> { get products_url(format: request_format) } }
  let!(:products) { create_list(:product, 3) } # Create some products for testing
  context "when format is HTML" do
    let(:request_format) { :html }
    context "when user is not authenticated" do
      include_context "as unauthenticated user"

      it_behaves_like "shows index page", format: :html
    end

    context "when user is a guest" do
      include_context "as guest user"

      it_behaves_like "shows index page", format: :html
    end

    context "when user is a admin user" do
      include_context "as admin user"

      it_behaves_like "shows index page", format: :html
    end
  end

  context "when format is JSON" do
    let(:request_format) { :json }
    context "when user is not authenticated" do
      include_context "as unauthenticated user"

      it_behaves_like "shows index page", format: :json
    end

    context "when user is a guest" do
      include_context "as guest user"

      it_behaves_like "shows index page", format: :json
    end

    context "when user is a admin user" do
      include_context "as admin user"

      it_behaves_like "shows index page", format: :json
    end
  end
end
