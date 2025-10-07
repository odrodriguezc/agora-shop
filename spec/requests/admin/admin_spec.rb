require 'rails_helper'

RSpec.describe "Admin access check", type: :request do
  describe "GET /admin/access_check" do
    let(:perform_request) { -> { get admin_access_check_url } }

    context "as an admin user" do
      include_context "as admin user"

      it "allows access" do
        perform_request.call
        expect(response).to have_http_status(:ok)
      end
    end

    context "as a non-admin user" do
      include_context "as authenticated user"

      it_behaves_like "denies access with authorization alert"
    end

    context "as an unauthenticated user" do
      include_context "as unauthenticated user"

      it_behaves_like "requires authentication"
    end
  end
end
