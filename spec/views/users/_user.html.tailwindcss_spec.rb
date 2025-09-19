require 'rails_helper'
require_relative './shared_examples/_user'

RSpec.describe "users/_user", type: :view do
  it_behaves_like "displays user details" do
    let(:user) { [ create_user(full_name: "Test User", email_address: "test@example.com") ] }
  end
end
