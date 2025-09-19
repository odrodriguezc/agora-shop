class User < ApplicationRecord
  MIN_PASSWORD_LENGTH_ALLOWED = 8
  MAX_PASSWORD_LENGTH_ALLOWED = 42
  rolify

  after_create :assign_default_role

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :password, length: { minimum: MIN_PASSWORD_LENGTH_ALLOWED, maximum: MAX_PASSWORD_LENGTH_ALLOWED }, allow_nil: true
  validates :email_address, presence: true, uniqueness:  { case_sensitive: false }

  # TODO: mouve to a service object
  def assign_default_role
    self.add_role(:guest) if self.roles.blank?
  end
end
