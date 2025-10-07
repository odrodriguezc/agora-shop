# Spec for the Users::Onboard service class.
#
# This test suite verifies the behavior of the `Users::Onboard` service,
# specifically its `#call` method. The service is responsible for onboarding
# a user by invoking other services such as `Users::AssignDefaultRole` and
# `Users::SendWelcomeEmail`.
#
# Test cases:
# - Ensures that the `Users::AssignDefaultRole` service is called with the
#   provided user object.
# - Ensures that the `Users::SendWelcomeEmail` service is called with the
#   provided user object.
#
# Mocks:
# - The `User` object is mocked using `instance_double`.
# - The `Users::AssignDefaultRole` and `Users::SendWelcomeEmail` services
#   are mocked to isolate the behavior of the `Users::Onboard` service.
require "rails_helper"

RSpec.describe Users::Onboard, type: :service do
  describe "#call" do
    let(:user) { instance_double("User") } # Mock user object
    let(:service) { described_class.new(user) }

    before do
      allow(Users::SendWelcomeEmail).to receive(:call)
      allow(Users::AssignDefaultRole).to receive(:call)
    end

    it "calls AssignDefaultRole service with the user" do
      expect(Users::AssignDefaultRole).to receive(:call).with(user)
      service.call
    end

    it "calls SendWelcomeEmail service with the user" do
      expect(Users::SendWelcomeEmail).to receive(:call).with(user)
      service.call
    end
  end
end
