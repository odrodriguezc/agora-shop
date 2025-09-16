require 'rails_helper'
require_relative './shared_examples/_user'
RSpec.describe "users/show", type: :view do
  fixtures :users
  before(:each) do
    @user = users(:test)
    assign(:user, @user)
  end

  it "renders the page title" do
    render
    expect(rendered).to have_content("Showing user")
  end

  it "renders the edit user link" do
    render
    expect(rendered).to have_link("Edit this user", href: edit_user_path(@user))
  end

  it "renders the back to users link" do
    render
    expect(rendered).to have_link("Back to users", href: users_path)
  end

  it "renders the destroy user button" do
    render
    expect(rendered).to have_selector("form[action='#{user_path(@user)}'][method='post']") do |form|
      expect(form).to have_selector("button", text: "Destroy this user")
    end
  end

  it_behaves_like "displays user details" do
    let(:user) { [ @user ] }
  end
end
