module Users
  class Base < ApplicationService
    def initialize(user)
      @user = user
    end

    private
    attr_reader :user
  end
end
