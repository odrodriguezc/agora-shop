class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authorize_user!, only: %i[ edit update destroy ]
  before_action :restrict_authenticated_user, only: %i[new create]

  # GET /users or /users.json
  def index
    @users = User.where(id: Current.user.id)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {}).permit(:fullname, :email_address, :password)
    end

    def current_user?
      @user == Current.user
    end

    # Only current user can edit/update/destroy their own account
    def authorize_user!
      return if current_user?
      respond_to do |format|
        format.html { redirect_to users_path, alert: "You are not authorized to perform this action." }
        format.json { head :forbidden }
      end
    end

    # Restrict to authenticated users from accessing new/create actions
    def restrict_authenticated_user
      return unless authenticated?
      respond_to do |format|
        format.html { redirect_to users_path, alert: "You are not authorized to perform this action." }
        format.json { head :forbidden }
      end
    end
end
