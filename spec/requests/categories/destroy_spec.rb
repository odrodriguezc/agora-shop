
require 'rails_helper'

RSpec.describe "DELETE /categories/:id", type: :request do
  let(:category) { create(:category) }
  let(:perform_request) { -> { delete category_url(category) } }

  context "when the format is HTML" do
    before { category }

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
      it_behaves_like "destroys category successfully"
    end
  end
end
