require 'rails_helper'
require_relative './shared_examples/_user'
RSpec.describe "users/_user", type: :view do
  fixtures :users

  # Pass context using a block to avoid eager evaluation
  it_behaves_like "displays user details" do
    let(:user) { [ users(:test) ] }
  end
end
