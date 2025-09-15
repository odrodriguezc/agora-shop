class User < ApplicationRecord
  include HasPublicUuid

  MIN_PASSWORD_LENGTH = 12
  MAX_PASSWORD_LENGTH = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness:  { case_sensitive: false }
  validates :password, presence: true
  validates :password, length: { minimum: MIN_PASSWORD_LENGTH, maximum: MAX_PASSWORD_LENGTH }, allow_nil: true
end
