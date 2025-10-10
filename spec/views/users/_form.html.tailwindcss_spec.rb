require 'rails_helper'

RSpec.describe "users/_form", type: :view do
  context "when rendering the form for a new user" do
    it_behaves_like "renders the user form correctly" do
      let(:user) { build_user }
    end
  end

  context "when rendering the form for an existing user" do
    it_behaves_like "renders the user form correctly" do
      let(:user) { create_user }
    end
  end
end
