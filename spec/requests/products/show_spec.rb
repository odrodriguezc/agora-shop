require 'rails_helper'

RSpec.describe "GET /products/:id", type: :request do
  let(:product) { create(:product) }
  let(:perform_request) { -> { get product_url(product, format: request_format) } }

  context "when the request format is HTML" do
    let(:request_format) { :html }
    context "when the user is unauthenticated" do
      include_context "as unauthenticated user"

      it_behaves_like "shows product successfully", format: :html
    end
    context "when the user is a guest user" do
      include_context "as guest user"

      it_behaves_like "shows product successfully", format: :html
    end
    context "when the user is an admin" do
      include_context "as admin user"

      it_behaves_like "shows product successfully", format: :html
    end
  end

  context "when the request format is JSON" do
    let(:request_format) { :json }
    context "when the user is unauthenticated" do
      include_context "as unauthenticated user"

      it_behaves_like "shows product successfully", format: :json
    end
    context "when the user is a guest user" do
      include_context "as guest user"

      it_behaves_like "shows product successfully", format: :json
    end
    context "when the user is an admin" do
      include_context "as admin user"

      it_behaves_like "shows product successfully", format: :json
    end
  end
end
