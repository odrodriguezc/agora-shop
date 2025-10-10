module UserHelpers
  def build_user(attrs = {})
    build(:user, **attrs)
  end

  def build_stubbed_user(attrs = {})
    build_stubbed(:user, **attrs)
  end

  def create_user(attrs = {})
    create(:user, **attrs)
  end

  def create_admin_user(attrs = {})
    create(:admin_user, **attrs)
  end

  def create_guest_user(attrs = {})
    create(:guest_user, **attrs)
  end

  def user_attributes(attrs = {})
    attributes_for(:user).merge(attrs)
  end

  def user_params(overrides = {})
    attrs = user_attributes.merge(overrides)
    attrs[:password_confirmation] ||= attrs[:password]
    { user: attrs }
  end

  def invalid_user_params
    user_params(full_name: "", email_address: "", password: "", password_confirmation: "")
  end

  def default_user_params
    user_params(
      full_name: "Spec User",
      email_address: "specuser@example.com",
      password: "password_12345"
    )
  end
end
