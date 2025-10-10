require 'rails_helper'

RSpec.describe "users/profile", type: :view do
  subject(:render_view) { render }

  let(:user) { create_user }

  before do
    assign(:user, user)
  end

  it "renders the profile heading" do
    render_view
    expect(rendered).to have_content("Profile")
  end

  it_behaves_like "displays user details" do
    let(:user) { [ create_user ] }
  end


  it "renders the edit link" do
    render_view

    expect(rendered).to have_link("Edit profile", href: edit_user_path(user))
  end

  it "renders navigation links" do
    render_view
    expect(rendered).to have_link("Back to users", href: users_path)
    expect(rendered).to have_link("Return home", href: root_path)
  end
end
