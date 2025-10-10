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
