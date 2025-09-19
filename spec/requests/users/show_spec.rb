require 'rails_helper'

# TODO: Add JSON request specs for this endpoint.

RSpec.describe "GET /users/:id", type: :request do
  context "when the user is authenticated" do
    include_context "as authenticated user"
    let(:perform_request) { -> { get user_url(other_user) } }

    it "returns a successful response for the requested user" do
      get user_url(current_user)
      expect(response).to be_successful
    end

    it_behaves_like "denies access with authorization alert"
  end

  context "when the user is an admin" do
    include_context "as admin user"

    it "allows viewing any user" do
      get user_url(other_user)

      expect(response).to be_successful
    end
  end

  context "when the user is unauthenticated" do
    include_context "as unauthenticated user"
    let(:perform_request) { -> { get user_url(other_user) } }

    it_behaves_like "requires authentication"
  end
end
