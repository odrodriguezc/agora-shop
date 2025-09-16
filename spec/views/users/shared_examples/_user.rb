RSpec.shared_examples "displays user details" do
  it "displays the user's attributes" do
    users = user || [ User.new(fullname: "Test User", email_address: "test@example.com", password: "password_12345") ]
    users.each do |u|
      render partial: "users/user", locals: { user: u }
      expect(rendered).to match(/#{u.fullname}/)
      expect(rendered).to match(/#{u.email_address}/)
    end
  end
end
