
# This shared example tests policies that expose public read access for specific actions.
# It ensures that the policy permits the specified actions when there is no user or when the user is a guest.
#
# @param actions [Array<Symbol>, Symbol] The actions to test for public read access.
#
# Example usage:
#   it_behaves_like "a policy exposing public read access", actions: [:show, :index]
RSpec.shared_examples "a policy exposing public read access" do |actions:|
  Array(actions).each do |action|
    context "##{action}" do
      context "when theere is no user" do
        let(:user) { nil }
        it { is_expected.to permit(action) }
      end

      context "when the user is not an admin" do
        let(:user) { not_admin_user }
        it { is_expected.to permit(action) }
      end
    end
  end
end
