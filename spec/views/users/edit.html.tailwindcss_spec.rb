require 'rails_helper'
require_relative './shared_examples/_form'

RSpec.describe "users/edit", type: :view do
  fixtures :users

  before(:each) do
    @user = users(:test)
    assign(:user, @user)
  end

  it "displays the page title 'Editing user'" do
    render
    expect(rendered).to have_content("Editing user")
  end

  it_behaves_like "renders the user form correctly" do
    let(:user) { @user }
  end

  it "displays a link to navigate back to the users index" do
    render
    expect(rendered).to have_link("Back to users", href: users_path)
  end

  it "displays a link to show this user" do
    render
    expect(rendered).to have_link("Show this user", href: user_path(@user))
  end
end
