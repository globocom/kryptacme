class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :admin_only

  # GET /users
  def index
    @users = User.filter(params.slice(:email, :contains, :starts_with))

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    if params[:user][:projects].present?
      @projects = Project.find(params[:user][:projects])
      @tmp_prj = (@user.projects + @projects).uniq
    end
    unless @tmp_prj.nil?
      @user.projects = @tmp_prj
    end
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.includes(:projects).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :role)
    end
end
