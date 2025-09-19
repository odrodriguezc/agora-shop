require 'rails_helper'
require_relative './shared_examples/_user'

RSpec.describe "users/index", type: :view do
  subject(:render_view) { render }

  let(:users) { create_list(:user, 2) }

  before do
    assign(:users, users)
  end

  it "displays the page title 'Users'" do
    render_view
    expect(rendered).to have_content("Users")
  end

  it "displays a button to create a new user" do
    render_view
    expect(rendered).to have_link("New user", href: new_user_path)
  end

  it "displays 'Show', 'Edit', and 'Destroy' buttons for each user" do
    render_view

    users.each do |user|
      expect(rendered).to have_link("Show", href: user_path(user))
      expect(rendered).to have_link("Edit", href: edit_user_path(user))
      expect(rendered).to have_selector("form[action='#{user_path(user)}'][method='post']") do |form|
        expect(form).to have_selector("button", text: "Destroy")
      end
    end
  end

  it_behaves_like "displays user details" do
    let(:user) { users }
  end

  context "when there are no users" do
    let(:users) { [] }

    it "displays a message indicating no users are found" do
      render_view
      expect(rendered).to have_content("No users found")
    end
  end
end
