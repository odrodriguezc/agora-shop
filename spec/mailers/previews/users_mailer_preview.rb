# Preview all emails at http://localhost:3000/rails/mailers/users_mailer_mailer
class UsersMailerPreview < ActionMailer::Preview
  def welcome_email
    UsersMailer.with(user: User.first).welcome_email
  end
end
