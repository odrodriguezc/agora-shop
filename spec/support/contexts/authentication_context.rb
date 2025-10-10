RSpec.shared_context "as authenticated user", type: :request do
  let(:current_user) { create_user }
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests

  before { sign_in_as(current_user) }
end

RSpec.shared_context "as unauthenticated user", type: :request do
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests
  before { sign_out }
end
