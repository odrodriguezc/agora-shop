require 'rails_helper'
require_relative './shared_examples/_form'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new)
  end

  it "displays the page title 'New user'" do
    render
    expect(rendered).to have_content("New user")
  end

  it_behaves_like "renders the user form correctly" do
    let(:user) { User.new }
  end

  it "displays a link to navigate back to the users index" do
    render
    expect(rendered).to have_link("Back to users", href: users_path)
  end
end
