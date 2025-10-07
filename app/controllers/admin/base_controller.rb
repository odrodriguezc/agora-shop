module Admin
  class BaseController < ApplicationController
    before_action :authorize_admin_access

    private

    def authorize_admin_access
      authorize :admin, :access?
    end
  end
end
