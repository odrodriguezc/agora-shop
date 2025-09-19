require 'rails_helper'

# TODO: Expand JSON request specs for admin and unauthenticated users.

RSpec.describe "GET /users/new", type: :request do
  context "when the user is authenticated" do
    include_context "as authenticated user"

    it "redirects to root path" do
      get new_user_url
      expect(response).to redirect_to(root_url)
    end

    it "returns a forbidden response for JSON requests" do
      get new_user_url(format: :json)

      expect(response).to have_http_status(:forbidden)
      expect(response.parsed_body).to include("error" => "not_authorized")
    end
  end

  context "when the user is an admin" do
    include_context "as admin user"

    it "renders the form successfully" do
      get new_user_url
      expect(response).to be_successful
    end
  end

  context "when the user is unauthenticated" do
    include_context "as unauthenticated user"

    it "renders the new user form successfully" do
      get new_user_url
      expect(response).to be_successful
    end
  end
end
