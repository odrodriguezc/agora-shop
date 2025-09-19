
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    describe "#email_address" do
      it "requires presence" do
        user = build_user(email_address: nil)

        expect(user).not_to be_valid
        expect(user.errors.added?(:email_address, :blank)).to be(true)
      end

      it "requires uniqueness" do
        existing_user = create_user
        user = build_user(email_address: existing_user.email_address)

        expect(user).not_to be_valid
        expect(user.errors.of_kind?(:email_address, :taken)).to be(true)
      end

      it "enforces case-insensitive uniqueness" do
        existing_user = create_user(email_address: "case_sensitive@example.com")
        user = build_user(email_address: existing_user.email_address.upcase)

        expect(user).not_to be_valid
        expect(user.errors.of_kind?(:email_address, :taken)).to be(true)
      end
    end

    describe "#password" do
      it "rejects passwords shorter than the minimum" do
        user = build_user(password: 'a' * (User::MIN_PASSWORD_LENGTH_ALLOWED - 1))

        expect(user).not_to be_valid
        expect(user.errors.added?(:password, :too_short, count: User::MIN_PASSWORD_LENGTH_ALLOWED)).to be(true)
      end

      it "accepts passwords at the minimum length" do
        user = build_user(password: 'a' * User::MIN_PASSWORD_LENGTH_ALLOWED)

        expect(user).to be_valid
      end

      it "accepts passwords at the maximum length" do
        max_length = User::MAX_PASSWORD_LENGTH_ALLOWED
        user = build_user(password: 'a' * max_length)

        expect(user).to be_valid
      end

      it "rejects passwords exceeding the maximum length" do
        max_length = User::MAX_PASSWORD_LENGTH_ALLOWED
        user = build_user(password: 'a' * (max_length + 1))

        expect(user).not_to be_valid
        expect(user.errors.added?(:password, :too_long, count: max_length)).to be(true)
      end

      it "validates password length on update" do
        user = create_user
        user.password = 'a'

        expect(user).not_to be_valid
        expect(user.errors.added?(:password, :too_short, count: User::MIN_PASSWORD_LENGTH_ALLOWED)).to be(true)
      end

      it "allows nil password when updating other attributes" do
        user = create_user
        user.email_address = 'new@example.com'

        expect(user).to be_valid
      end
    end
  end

  describe "callbacks" do
    describe "#assign_default_role" do
      it "adds the guest role when no roles are present" do
        user = create_user

        expect(user.has_role?(:guest)).to be(true)
      end

      it "does not add the guest role when roles already exist" do
        user = create_user
        user.remove_role(:guest)
        user.add_role(:admin)

        expect {
          user.send(:assign_default_role)
        }.not_to change { user.roles.pluck(:name).sort }

        expect(user.has_role?(:admin)).to be(true)
        expect(user.has_role?(:guest)).to be(false)
      end
    end
  end

  describe "associations" do
    it "destroys dependent sessions" do
      user = create_user
      session = user.sessions.create!(ip_address: "127.0.0.1", user_agent: "RSpec")

      user.destroy

      expect(Session.where(id: session.id)).not_to exist
    end
  end

  describe "normalization" do
    describe "#email_address" do
      it "normalizes email before validation" do
        user = build_user(email_address: "  TEST@EXAMPLE.COM  ")

        user.valid?

        expect(user.email_address).to eq("test@example.com")
      end

      it "normalizes email on update" do
        user = create_user(email_address: "initial@example.com")

        user.update!(email_address: "  MixedCase@Example.COM  ")

        expect(user.reload.email_address).to eq("mixedcase@example.com")
      end
    end
  end

  describe "#authenticate" do
    let(:stored_user) { create_user(password: 'password_123') }

    context "with incorrect password" do
      it "returns false" do
        expect(stored_user.authenticate("wrong_password")).to be_falsey
      end
    end

    context "with correct password" do
      it "returns the user" do
        expect(stored_user.authenticate('password_123')).to eq(stored_user)
      end
    end
  end
end
