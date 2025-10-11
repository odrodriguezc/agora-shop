
require 'rails_helper'

RSpec.describe "PATCH /categories/:id", type: :request do
  let(:existing_category) { create(:category) }
  let(:valid_params) { { category: { name: "Updated Category Name" } } }
  let(:invalid_params) { { category: { name: "" } } }
  let(:updated_category) { Category.find(existing_category.id) }
  let(:perform_request) { -> { patch category_url(existing_category, format: request_format), params: valid_params } }

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
        it_behaves_like "updates category successfully", format: :html
      end

      context "with invalid parameters" do
        it_behaves_like "rejects invalid category update", format: :html
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
        it_behaves_like "updates category successfully", format: :json
      end

      context "with invalid parameters" do
        it_behaves_like "rejects invalid category update", format: :json
      end
    end
  end
end
