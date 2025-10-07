class UsersMailer < ApplicationMailer
  def welcome_email
    @user = User.find(params[:user_id])
    @greeting_name = @user.full_name.presence || "there"
    mail(to: email_address_with_name(@user.email_address, @user.full_name), subject: "Welcome to Agora Shop!")
  end
end
