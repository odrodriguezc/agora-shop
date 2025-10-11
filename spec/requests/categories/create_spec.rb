
require 'rails_helper'

RSpec.describe "POST /categories", type: :request do
  let(:valid_params) { default_category_params }
  let(:invalid_params) { invalid_category_params }
  let(:created_category) { Category.last }
  let(:perform_request) { -> { post categories_url(format: request_format, params: valid_params) } }

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
        include_examples "creates category successfully", format: :html
      end

      context "with invalid parameters" do
        include_examples "rejects invalid category", format: :html
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
        include_examples "creates category successfully", format: :json
      end

      context "with invalid parameters" do
        include_examples "rejects invalid category", format: :json
      end
    end
  end
end
