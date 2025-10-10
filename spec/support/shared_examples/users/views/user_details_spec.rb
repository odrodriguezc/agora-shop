
# This shared example tests the rendering of user details in a partial view.
# It verifies that the user's key attributes (full name and email address)
# are displayed correctly within the DOM structure.
#
# Usage:
# Include this shared example in your RSpec test suite to ensure that the
# "users/user" partial correctly renders the provided user details.
#
# Example:
# RSpec.describe "User Details Partial", type: :view do
#   let(:user) { create(:user) }
#
#   it_behaves_like "displays user details"
# end
#
# Requirements:
# - The `user` object must respond to `full_name` and `email_address`.
# - The `ActionView::RecordIdentifier.dom_id` method is used to generate
#   the DOM ID for the user, so ensure the user model is compatible with it.
# - The partial being tested should be located at "users/_user.html.erb".
RSpec.shared_examples "displays user details" do
  it "renders the user's key attributes" do
    Array(user).each do |u|
      render partial: "users/user", locals: { user: u }

      dom_id = ActionView::RecordIdentifier.dom_id(u)

      assert_select "##{dom_id}" do
        assert_select "p", text: /#{Regexp.escape(u.full_name)}/
        assert_select "p", text: /#{Regexp.escape(u.email_address)}/
      end
    end
  end
end
