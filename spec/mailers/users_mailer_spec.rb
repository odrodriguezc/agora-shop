# This is a test suite for the UsersMailer class, specifically testing the #welcome_email method.
#
# The #welcome_email method is expected to send a welcome email to a user with the following properties:
# - The recipient's email address is set to the user's email_address.
# - The sender's email address is "no-reply@example.com".
# - The subject of the email is "Welcome to Agora Shop!".
# - The email body includes a personalized greeting based on the user's full_name, or defaults to "there" if full_name is nil.
#
# Shared examples are used to test the email content for both cases:
# 1. When the user has a full_name, the greeting includes the full_name.
# 2. When the user does not have a full_name, the greeting defaults to "there".
#
# The test suite uses aggregate_failures to ensure all expectations are evaluated even if one fails.
require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  describe "#welcome_email" do
    subject(:mail) { described_class.with(user_id: user.id).welcome_email }

    let(:html_body) { mail.html_part&.body&.decoded || mail.body.decoded }
    let(:text_body) { mail.text_part&.body&.decoded || mail.body.decoded }

    shared_examples "welcome email" do |greeting|
      it "delivers the welcome message" do
        aggregate_failures do
          expect(mail.to).to contain_exactly(user.email_address)
          expect(mail.from).to contain_exactly("no-reply@example.com")
          expect(mail.subject).to eq("Welcome to Agora Shop!")
          expect(html_body).to include("Hi #{greeting}")
          expect(text_body).to include("Hi #{greeting}")
        end
      end
    end

    context "with full name" do
      let(:user) { create_user(email_address: "welcome@example.com", full_name: "Welcome User") }

      it_behaves_like "welcome email", "Welcome User"
    end

    context "without full name" do
      let(:user) { create_user(email_address: "nameless@example.com", full_name: nil) }

      it_behaves_like "welcome email", "there"
    end
  end
end
