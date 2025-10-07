class UsersMailer < ApplicationMailer
  default from: "no-reply@example.com"
  def welcome_email
    @user = User.find(params[:user_id])
    @greeting_name = @user.full_name.presence || "there"
    mail(to: @user.email_address, subject: "Welcome to Agora Shop!")
  end
end
