# Authorizes access to admin-only areas like Mission Control Jobs.
# Expects the record to represent the admin namespace (symbol or class).
class AdminPolicy < ApplicationPolicy
  # Only users with the admin role can access admin areas
  #  access? is the primary method Pundit will call
  #  access? to handle all admin actions in particular the mission control jobs engine
  def access?
    admin?
  end

  alias_method :index?, :access?
  alias_method :show?, :access?
  alias_method :create?, :access?
  alias_method :update?, :access?
  alias_method :destroy?, :access?

  private

  def admin?
    user&.has_role?(:admin)
  end
end
