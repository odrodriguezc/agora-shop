require 'rails_helper'

RSpec.describe User, type: :model do
  # Include the shared examples for "has public uuid"
  it_behaves_like 'has public uuid', { email_address: 'test@example.com', password_digest: 'password123' }
end
