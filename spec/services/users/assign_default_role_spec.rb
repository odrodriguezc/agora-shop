require 'rails_helper'

RSpec.describe Users::AssignDefaultRole do
  describe "#call" do
    let(:user) { create_user }

    subject { described_class.new(user) }
    before { user.roles.clear }
    context "when the user has no roles" do
      it "assigns the default role to the user" do
        expect {
          subject.call
        }.to change { user.roles.pluck(:name) }.from([]).to([ User::DEFAULT_ROLE.to_s ])
      end
    end

    context "when the user already has roles" do
      it "does not assign the default role" do
        user.add_role(:admin)

        expect {
          subject.call
        }.not_to change { user.roles.pluck(:name) }

        expect(user.has_role?(User::DEFAULT_ROLE)).to be(false)
      end
    end
  end
end
