module Users
  class SendWelcomeEmail < Users::Base
    def call
      nil unless user.email_address.present?

      UsersMailer.with(user_id: user.id).welcome_email.deliver_later
    end
  end
end
