RSpec.shared_examples "renders the user form correctly" do
  it "renders the form with input fields and placeholders" do
    @user = user
    form_action = @user.persisted? ? user_path(@user) : users_path

    render partial: "users/form", locals: { user: @user }

    assert_select "form[action=?][method=?]", form_action, "post" do
      assert_select "input[name=?][placeholder=?]", "user[fullname]", "Enter your full name"
      assert_select "input[name=?][placeholder=?]", "user[email_address]", "Enter your email address"
      assert_select "input[name=?][placeholder=?]", "user[password]", "Enter your password"
    end
  end

  it "renders the submit button with the correct text" do
    @user = user
    submit_button_text = @user.persisted? ? "Update User" : "Create User"

    render partial: "users/form", locals: { user: @user }

    assert_select "input[type=?][value=?]", "submit", submit_button_text
  end

  it "renders labels for input fields" do
    @user = user
    render partial: "users/form", locals: { user: @user }

    assert_select "label[for=?]", "user_fullname", text: "Fullname"
    assert_select "label[for=?]", "user_email_address", text: "Email Address"
    assert_select "label[for=?]", "user_password", text: "Password"
  end
end
