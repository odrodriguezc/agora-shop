# @documentation
# This matcher checks if a Pundit policy permits a specific action for a given user and record.
# Usage:
#   expect(UserPolicy.new(user, record)).to permit(:action)
#
# Example:
#   expect(UserPolicy.new(current_user, @user)).to permit(:index)
#
# This will pass if the `index?` method in `UserPolicy` returns true for the given user and record.
RSpec::Matchers.define :permit do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message_for_should do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_for_should_not do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}."
  end
end
