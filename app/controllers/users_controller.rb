class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :admin_only

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    unless @projects.nil?
      @project_uniq = (@user.projects + @projects).uniq
      @user.projects = @project_uniq
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
      if params.has_key?(:projects_id)
        @projects = Project.find(params[:projects_id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:projects_id, :email, :role)
    end
end
