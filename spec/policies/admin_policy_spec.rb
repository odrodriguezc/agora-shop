require 'rails_helper'

RSpec.describe AdminPolicy, type: :policy do
  subject(:policy) { described_class.new(user, record) }

  let(:record) { :admin }
  let(:admin_user) { create_admin_user }
  let(:not_admin_user) { create_guest_user }

  context "when the user is an admin" do
    let(:user) { admin_user }

    it_behaves_like "a policy permitting a role admin to access",
                    allow: :access
  end
  context "when the user lacks the admin role" do
    let(:user) { not_admin_user }

    it_behaves_like "a policy denying access for non-admin users",
                    denied: :access
  end

  context "when there is no user" do
    let(:user) { nil }

    it_behaves_like "a policy denying access for non-admin users",
                    denied: :access
  end
end
