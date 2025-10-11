
RSpec.shared_examples "a policy exposing public read access" do |actions:|
  Array(actions).each do |action|
    context "##{action}" do
      context "when theere is no user" do
        let(:user) { nil }
        it { is_expected.to permit(action) }
      end

      context "when the user is a guest" do
        let(:user) { not_admin_user }
        it { is_expected.to permit(action) }
      end
    end
  end
end
