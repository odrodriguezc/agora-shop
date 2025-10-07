require 'rails_helper'

RSpec.describe AdminPolicy, type: :policy do
  subject(:policy) { described_class.new(user, record) }

  let(:record) { :admin }
  let(:admin_user) { create_admin_user }
  let(:non_admin_user) { create_guest_user }

  it_behaves_like "a policy permitting a role admin to access",
                  allow: :access

  context "when the user lacks the admin role" do
    let(:user) { non_admin_user }

    it { is_expected.not_to permit(:access) }
  end

  context "when there is no user" do
    let(:user) { nil }

    it { is_expected.not_to permit(:access) }
  end
end
