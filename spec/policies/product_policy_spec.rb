require 'rails_helper'

RSpec.describe ProductPolicy, type: :policy do
  subject { described_class.new(user, product) }
  let(:product) { create(:product) }
  let(:user) { nil }
  let(:admin_user) { create_admin_user }
  let(:guest_user) { create_guest_user }

  it_behaves_like "a policy exposing public read access", actions: %i[show index]
  it_behaves_like "a policy permitting a role admin to access",
                  allow: %i[show update edit destroy index new create]
end
