require 'rails_helper'
require_relative './shared_examples/_form'

RSpec.describe "users/new", type: :view do
  subject(:render_view) { render }

  before do
    assign(:user, build_user)
  end

  it "displays the page title 'New user'" do
    render_view
    expect(rendered).to have_content("New user")
  end

  it_behaves_like "renders the user form correctly" do
    let(:user) { build_user }
  end

  it "displays a link to navigate back to the users index" do
    render_view
    expect(rendered).to have_link("Back to users", href: users_path)
  end
end
