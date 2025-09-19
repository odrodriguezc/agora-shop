class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  # Use Current.user as the user for Pundit
  def current_user
    resume_session # ensure Current.session is set for actions that are allowed unauthenticated
    Current.user
  end

  private
  def user_not_authorized
    # TODO : Add locale support
    message = "You are not authorized to perform this action."
    respond_to do |format|
      format.html { redirect_to(request.referrer || root_path, alert: message) }
      format.json { render json: { error: "not_authorized", message: message }, status: :forbidden }
    end
  end
end
