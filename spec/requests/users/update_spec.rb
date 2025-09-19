require 'rails_helper'

# TODO: Add JSON request specs for this endpoint.

RSpec.describe "PATCH /users/:id", type: :request do
  let(:valid_params) do
    user_params(
      full_name: "Updated Name",
      email_address: "updated@example.com",
      password: "updated_password"
    )
  end

  let(:invalid_params) { invalid_user_params }

  context "when the user is authenticated" do
    include_context "as authenticated user"
    context "when updating their own information" do
      it "updates the user with the provided attributes" do
        patch user_url(current_user), params: valid_params

        current_user.reload
        expect(current_user.full_name).to eq("Updated Name")
        expect(current_user.email_address).to eq("updated@example.com")
        expect(current_user.authenticate("updated_password")).to be_truthy
      end

      it "redirects to the user's profile" do
        patch user_url(current_user), params: valid_params

        expect(response).to redirect_to(user_url(current_user))
      end

      it "does not update with invalid parameters" do
        expect {
          patch user_url(current_user), params: invalid_params
        }.not_to change { current_user.reload.email_address }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when updating another user's information" do
      let(:perform_request) { -> { patch user_url(other_user), params: valid_params } }

      it_behaves_like "denies access with authorization alert"
    end
  end

  context "when the user is an admin" do
    include_context "as admin user"

    it "updates another user's information" do
      patch user_url(other_user), params: valid_params

      other_user.reload
      expect(other_user.full_name).to eq("Updated Name")
      expect(response).to redirect_to(user_url(other_user))
    end
  end

  context "when the user is unauthenticated" do
    include_context "as unauthenticated user"
    let(:perform_request) { -> { patch user_url(other_user), params: valid_params } }

    it_behaves_like "requires authentication"
  end
end
