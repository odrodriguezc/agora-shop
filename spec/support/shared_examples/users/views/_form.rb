RSpec.shared_examples "renders the user form correctly" do
  subject(:render_form) { render partial: "users/form", locals: { user: user } }

  let(:form_action) { user.persisted? ? user_path(user) : users_path }
  let(:submit_label) { user.persisted? ? "Update User" : "Create User" }

  it "renders the form with input fields and placeholders" do
    render_form

    assert_select "form[action=?][method=?]", form_action, "post" do
      assert_select "input[name=?][placeholder=?]", "user[full_name]", "Enter your full name"
      assert_select "input[name=?][placeholder=?]", "user[email_address]", "Enter your email address"
      assert_select "input[name=?][placeholder=?]", "user[password]", "Enter your password"
      assert_select "input[name=?][placeholder=?]", "user[password_confirmation]", "Confirm your password"
    end
  end

  it "renders the submit button with the correct text" do
    render_form

    assert_select "input[type=?][value=?]", "submit", submit_label
  end

  it "renders labels for input fields" do
    render_form

    assert_select "label[for=?]", "user_full_name", text: "Full Name"
    assert_select "label[for=?]", "user_email_address", text: "Email Address"
    assert_select "label[for=?]", "user_password", text: "Password"
    assert_select "label[for=?]", "user_password_confirmation", text: "Password Confirmation"
  end
end
