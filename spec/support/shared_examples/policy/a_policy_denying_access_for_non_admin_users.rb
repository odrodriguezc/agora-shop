
# This shared example tests that a policy denies access to specific actions
# for users who do not have the admin role.
#
# @param denied [Array<Symbol>, Symbol] A single action or an array of actions
#   that should be denied for non-admin users. Must include at least one action.
#
# @example Usage
#   it_behaves_like "a policy denying access for non-admin users", denied: [:edit, :update]
#
# @raise [ArgumentError] If the `denied` parameter is empty.
RSpec.shared_examples "a policy denying access for non-admin users" do |denied:|
  denied_actions = Array(denied) # normalize to array

  raise ArgumentError, "denied must include at least one action" if denied_actions.empty?

  context "when the user has not role admin" do
    let(:user) { not_admin_user }

    denied_actions.each do |action|
      it { is_expected.not_to permit(action) }
    end
  end
end
