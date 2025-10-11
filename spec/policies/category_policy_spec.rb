RSpec.describe CategoryPolicy do
  subject { described_class.new(user, record) }
  let(:record) { create(:category) } # The category record being accessed
  let(:admin_user) { create_admin_user }
  let(:not_admin_user) { create_guest_user }

  context "when the user is an admin" do
    let(:user) { admin_user }

    it_behaves_like "a policy permitting a role admin to access",
                    allow: %i[show update edit destroy index new create]
  end
  context "when the user lacks the admin role" do
    let(:user) { not_admin_user }

    it_behaves_like "a policy denying access for non-admin users",
                    denied: %i[update edit destroy new create]

    it_behaves_like "a policy exposing public read access",
                    actions: %i[show index]
  end

  context "when the user is nil" do
    let(:user) { nil }

    it_behaves_like "a policy denying access for non-admin users",
                    denied: %i[ update edit destroy new create]
  end
end
