RSpec.shared_context "as admin user", type: :request do
  let(:current_user) { create_admin_user }
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests

  before { sign_in_as(current_user) }
end
