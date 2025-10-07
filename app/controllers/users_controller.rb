class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  before_action :set_user, only: %i[ show profile edit update destroy ]

  # GET /users or /users.json
  def index
    authorize User
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    authorize @user
  end

  def profile
    authorize @user
  end

  # GET /users/new
  def new
    authorize @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users or /users.json
  def create
    authorize @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # Trigger onboarding process
        # TODO: move to a background job and a callback
        Users::Onboard.call(@user)
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
    authorize @user
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
    authorize @user
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
      .permit(:full_name, :email_address, :password, :password_confirmation)
    end
end
