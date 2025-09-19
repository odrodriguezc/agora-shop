# Shared examples for testing policies that grant access to a "role admin" user
# Usage:
#   it_behaves_like "a policy permitting role admin to access", allow: [:index, :show]
#
# Parameters:
#   allow: A symbol or array of symbols representing the actions that should be permitted for the role admin user.
#          This parameter is required and must include at least one action.
#
# Example:
#   RSpec.describe SomePolicy do
#     it_behaves_like "a policy permitting role admin to access", allow: [:index, :show]
#   end
RSpec.shared_examples "a policy permitting a role admin to access" do |allow:|
  allowed_actions = Array(allow) # normalize to array

  raise ArgumentError, "allow must include at least one action" if allowed_actions.empty?

  context "when the user has role admin" do
    let(:user) { admin_user }

    allowed_actions.each do |action|
      it { should permit(action) }
    end
  end
end
