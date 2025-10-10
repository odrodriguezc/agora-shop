require 'rails_helper'

RSpec.describe "users/show", type: :view do
  subject(:render_view) { render }

  let(:user) { create_user }

  before do
    assign(:user, user)
  end

  it "renders the page title" do
    render_view
    expect(rendered).to have_content("Showing user")
  end

  it "renders the edit user link" do
    render_view
    expect(rendered).to have_link("Edit this user", href: edit_user_path(user))
  end

  it "renders the back to users link" do
    render_view
    expect(rendered).to have_link("Back to users", href: users_path)
  end

  it "renders the destroy user button" do
    render_view
    expect(rendered).to have_selector("form[action='#{user_path(user)}'][method='post']") do |form|
      expect(form).to have_selector("button", text: "Destroy this user")
    end
  end

  it_behaves_like "displays user details" do
    let(:user) { [ create_user ] }
  end
end
