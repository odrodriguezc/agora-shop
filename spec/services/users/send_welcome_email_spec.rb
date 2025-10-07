require "rails_helper"

RSpec.describe Users::SendWelcomeEmail, type: :service do
  include ActiveJob::TestHelper

  let(:user) { create_user(email_address: "welcome@example.com") }
  let(:emailess_user) { build_user(email_address: nil) }
  subject(:send_welcome_email) { described_class.call(user) }

  describe ".call" do
    it "enqueues the welcome email job" do
      expect {
        send_welcome_email
      }.to have_enqueued_mail(UsersMailer, :welcome_email).with(params: { user_id: user.id }, args: [])
    end

    it "does not enqueue the job if email is missing" do
      expect {
        send_welcome_email
      }.not_to have_enqueued_mail(UsersMailer, :welcome_email).with(params: { user_id: emailess_user.id }, args: [])
    end
  end
end
