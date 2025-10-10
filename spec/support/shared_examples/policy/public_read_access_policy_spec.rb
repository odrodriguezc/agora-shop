
# This shared example tests a policy that exposes public read access for specified actions.
# It ensures that the policy permits access to the given actions when:
# - There is no user (user is nil).
# - The user is a guest (guest_user).
#
# Parameters:
# - actions: An array of actions to test for public read access.
#
# Usage:
# Include this shared example in your policy specs and pass the actions to test as an argument.
# Example:
#   it_behaves_like "a policy exposing public read access", actions: [:show, :index]
RSpec.shared_examples "a policy exposing public read access" do |actions:|
  Array(actions).each do |action|
    context "##{action}" do
      context "when theere is no user" do
        let(:user) { nil }
        it { is_expected.to permit(action) }
      end

      context "when the user is a guest" do
        let(:user) { guest_user }
        it { is_expected.to permit(action) }
      end
    end
  end
end
