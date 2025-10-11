
require 'rails_helper'

RSpec.describe "GET /categories/:id/edit", type: :request do
  let(:created_category) { create(:category) }
  let(:perform_request) { -> { get edit_category_url(created_category, format: request_format) } }

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
      it_behaves_like "shows edit category page", format: :html
    end
  end

  # TODO: Complete test for JSON format if needed
end
