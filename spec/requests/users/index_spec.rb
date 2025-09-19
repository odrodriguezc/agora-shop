require 'rails_helper'

RSpec.describe "GET /users", type: :request do
  context "when the user is an admin" do
    include_context "as admin user"
    it "returns a successful response" do
      get users_url

      expect(response).to be_successful
      expect(response).to render_template(:index)
    end

    it "supports JSON responses" do
      get users_url(format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to be_an(Array)
    end
  end

  context "when the user is authenticated but not an admin" do
    include_context "as authenticated user"
    let(:perform_request) { -> { get users_url } }

    it_behaves_like "denies access with authorization alert"
  end

  context "when the user is unauthenticated" do
    include_context "as unauthenticated user"
    let(:perform_request) { -> { get users_url } }

    it_behaves_like "requires authentication"
  end
end
