
require 'rails_helper'
# To avoid Ruby LSP issues
Rails.root.glob('spec/models/concerns/*.rb').sort_by(&:to_s).each { |f| require f }
RSpec.describe User, type: :model do
  fixtures :users

  # Include the shared examples for "has public uuid"
  # Shared example defined in spec/models/concerns/has_public_uuid.rb
  valid_attributes = { email_address: 'testuniq@example.com', password: "password_123" }

  # Test validations
  describe "validations" do
    describe "#email_address" do
      it "should be present" do
        user = User.new(password: valid_attributes[:password])
        expect(user.valid?).to be_falsey
        expect(user.errors[:email_address]).to include("can't be blank")
      end

      it "should be unique" do
        existing_user = users(:test)
        user = User.new(email_address: existing_user.email_address, password: valid_attributes[:password])
        expect(user.valid?).to be_falsey
        expect(user.errors[:email_address]).to include("has already been taken")
      end

      it "should be unique regardless of case" do
        existing_user = users(:test)
        uppercase_email = existing_user.email_address.upcase
        user = User.new(email_address: uppercase_email, password: valid_attributes[:password])
        expect(user.valid?).to be_falsey
        expect(user.errors[:email_address]).to include("has already been taken")
      end
    end

    describe "#password" do
      it 'should rejects minimum password length' do
        user = User.new(valid_attributes.merge(password: 'a' * (User::MIN_PASSWORD_LENGTH - 1)))
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is #{User::MIN_PASSWORD_LENGTH} characters)")
      end

      it 'should accepts password at minimum length' do
        user = User.new(valid_attributes.merge(password: 'a' * User::MIN_PASSWORD_LENGTH))
        expect(user).to be_valid
      end

      it 'should accepts password at maximum length' do
        user = User.new(valid_attributes.merge(password: 'a' * User::MAX_PASSWORD_LENGTH_ALLOWED))
        expect(user).to be_valid
      end

      it 'should rejects password exceeding maximum length' do
        user = User.new(valid_attributes.merge(password: 'a' * (User::MAX_PASSWORD_LENGTH_ALLOWED + 1)))
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too long (maximum is #{User::MAX_PASSWORD_LENGTH_ALLOWED} characters)")
      end

      it 'should validates password length on update' do
        user = User.create!(valid_attributes)
        user.password = 'a'
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is #{User::MIN_PASSWORD_LENGTH} characters)")
      end

      it 'should allows nil password when updating other attributes' do
        user = User.create!(valid_attributes)
        user.email_address = 'new@example.com'
        expect(user).to be_valid
      end
    end
  end

  describe "normalization" do
    describe "#email_address" do
      it "should normalize email_address before validation" do
        user = User.new(email_address: "  TEST@EXAMPLE.COM  ")
        user.valid?
        expect(user.email_address).to eq("test@example.com")
      end
    end
  end

  describe "#authenticate" do
  context "with incorrect password" do
    it "should return false - not authenticate" do
      user = users(:test)
      expect(user.authenticate("wrong_password")).to be_falsey
    end
  end
    context "with correct password" do
      it "should return user - authenticate" do
        user = users(:test)
        expect(user.authenticate(valid_attributes[:password])).to eq(user)
      end
    end
  end
end
