require 'rails_helper'
require_relative './shared_examples/_form'

RSpec.describe "users/edit", type: :view do
  subject(:render_view) { render }

  let(:user) { create_user }

  before do
    assign(:user, user)
  end

  it "displays the page title 'Editing user'" do
    render_view
    expect(rendered).to have_content("Editing user")
  end

  it_behaves_like "renders the user form correctly" do
    let(:user) { create_user }
  end

  it "displays a link to navigate back to the users index" do
    render_view
    expect(rendered).to have_link("Back to users", href: users_path)
  end

  it "displays a link to show this user" do
    render_view
    expect(rendered).to have_link("Show this user", href: user_path(user))
  end
end
