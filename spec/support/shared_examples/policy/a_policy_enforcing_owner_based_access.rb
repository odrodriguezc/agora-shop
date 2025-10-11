# Shared example to verify that a policy grants access to record owners
# while forbidding the same actions to non-owners.
#
# Usage:
#   it_behaves_like "a policy enforcing owner-based access", allow: [:show, :edit], forbid: [:destroy]
# Parameters:
#   allow: Symbol or Array of Symbols representing actions allowed for owners
#  forbid: Symbol or Array of Symbols representing actions forbidden for owners (optional)
#
# The test context must define:
#   let(:owner) { create(:user) } - the user who owns the record
#   let(:non_owner) { create(:user) } - a different user who does not own the record
#   let(:record) { create(:model, user: owner) } - the record being tested, associated with the owner
#
# Example:
#   RSpec.describe SomeModelPolicy do
#     let(:owner) { create(:user) }
#     let(:non_owner) { create(:user) }
#     let(:record) { create(:some_model, user: owner) }
#
#     subject { described_class.new(user, record) }
#
#     it_behaves_like "a policy enforcing owner-based access", allow: [:show, :edit], forbid: [:destroy]
#   end
RSpec.shared_examples "a policy enforcing owner-based access", type: :policy do |allow:, forbid: []|
  allowed_actions = Array(allow) # normalize to array
  forbidden_actions = Array(forbid)

  raise ArgumentError, "allow must include at least one action" if allowed_actions.empty?

  context "when the user owns the record" do
    let(:user) { owner }

    allowed_actions.each do |action|
      it { should permit(action) }
    end

    forbidden_actions.each do |action|
      it { should_not permit(action) }
    end
  end

  context "when the user does not own the record" do
    let(:user) { non_owner }

    (allowed_actions + forbidden_actions).each do |action|
      it { should_not permit(action) }
    end
  end
end
