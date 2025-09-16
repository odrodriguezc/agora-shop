require 'rails_helper'
require_relative './shared_examples/_form'

RSpec.describe "users/_form", type: :view do
  fixtures :users

  context "when rendering the form for a new user" do
    it_behaves_like "renders the user form correctly" do
      let(:user) { User.new }
    end
  end

  context "when rendering the form for an existing user" do
    it_behaves_like "renders the user form correctly" do
      let(:user) { users(:test) }
    end
  end
end
