require 'rails_helper'

# TODO: Add JSON request specs for this endpoint.

RSpec.describe "DELETE /users/:id", type: :request do
  context "when the user is unauthenticated" do
    include_context "as unauthenticated user"
    let(:perform_request) { -> { delete user_url(other_user) } }

    it_behaves_like "requires authentication"
  end

  context "when the user is authenticated" do
    include_context "as authenticated user"

    context "when deleting their own account" do
      it "deletes the specified user" do
        expect {
          delete user_url(current_user)
        }.to change(User, :count).by(-1)
      end

      it "redirects to users" do
        delete user_url(current_user)

        expect(response).to redirect_to(users_url)
      end
    end

    context "when deleting another user's account" do
      let(:perform_request) { -> { delete user_url(other_user) } }

      it "does not allow the deletion" do
        expect { perform_request.call }.not_to change(User, :count)
      end

      it_behaves_like "denies access with authorization alert"
    end
  end

  context "when the user is an admin" do
    include_context "as admin user"

    it "deletes the selected user" do
      expect {
        delete user_url(other_user)
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(users_url)
    end
  end
end
