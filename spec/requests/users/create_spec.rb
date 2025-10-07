require 'rails_helper'

RSpec.describe "POST /users", type: :request do
  let(:valid_params) { default_user_params }
  let(:invalid_params) { invalid_user_params }
  let(:submitted_email) { valid_params[:user][:email_address] }
  let(:created_user) { User.find_by(email_address: submitted_email) }

  context "when the request format is HTML" do
    context "when the user is authenticated" do
      include_context "as authenticated user"
      let(:perform_request) { -> { post users_url, params: valid_params } }

      it_behaves_like "denies access with authorization alert"

      it "does not create a user" do
        expect { perform_request.call }.not_to change(User, :count)
      end

      it "redirects back to the referrer when present" do
        referer = new_user_url

        post users_url, params: valid_params, headers: { 'HTTP_REFERER' => referer }

        expect(response).to redirect_to(referer)
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when the user is unauthenticated" do
      include_context "as unauthenticated user"
      context "when the HTML params are valid" do
        it "creates a user and redirects to the profile page" do
          expect {
            post users_url, params: valid_params
          }.to change(User, :count).by(1)

          expect(response).to redirect_to(user_url(created_user))
          expect(flash[:notice]).to eq("User was successfully created.")
        end

        it "enqueues the welcome email" do
          mail = nil

          with_test_queue_adapter do
            expect {
               post users_url, params: valid_params
            }.to have_enqueued_mail(UsersMailer, :welcome_email)
            perform_enqueued_jobs
            mail = ActionMailer::Base.deliveries.last
            expect(mail.to).to contain_exactly(submitted_email)
            expect(mail.subject).to eq("Welcome to Agora Shop!")
          end
        end
      end

      context "when the HTML params are invalid" do
        it "does not create a user" do
          expect {
            post users_url, params: invalid_params
          }.not_to change(User, :count)

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "does not enqueue the welcome email" do
          with_test_queue_adapter do
            expect {
              post users_url, params: invalid_params
            }.not_to have_enqueued_mail(UsersMailer, :welcome_email)
            perform_enqueued_jobs

            expect(ActionMailer::Base.deliveries).to be_empty
          end
        end
      end
    end
  end
  context "when the request format is JSON" do
    context "when the JSON payload is valid" do
      it "creates the user and returns the serialized payload" do
        expect {
          post users_url, params: valid_params, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to include(
          "full_name" => valid_params[:user][:full_name],
          "email_address" => valid_params[:user][:email_address]
        )
        expect(response.headers['Location']).to eq(user_url(created_user))
      end
    end

    context "when the JSON payload is invalid" do
      it "returns validation errors with a 422 status" do
        expect {
          post users_url, params: invalid_params, as: :json
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body.keys).to include("email_address", "password")
      end
    end
  end

  # Ensures a clean state for ActiveJob tests
  def with_test_queue_adapter
    clear_enqueued_jobs
    clear_performed_jobs
    ActionMailer::Base.deliveries.clear

    yield
  ensure
    clear_enqueued_jobs
    clear_performed_jobs
    ActionMailer::Base.deliveries.clear
  end
end
