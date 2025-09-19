require 'rails_helper'

# TODO: Add JSON request specs for this endpoint.

RSpec.describe "GET /users/:id/edit", type: :request do
  context "when the user is authenticated" do
    include_context "as authenticated user"
    let(:perform_request) { -> { get edit_user_url(other_user) } }

    it "renders the edit form for the current user" do
      get edit_user_url(current_user)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end

    it_behaves_like "denies access with authorization alert"
  end

  context "when the user is an admin" do
    include_context "as admin user"

    it "renders the edit form for any user" do
      get edit_user_url(other_user)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  context "when the user is unauthenticated" do
    include_context "as unauthenticated user"
    let(:perform_request) { -> { get edit_user_url(other_user) } }

    it_behaves_like "requires authentication"
  end
end
