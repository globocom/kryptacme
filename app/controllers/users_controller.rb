class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    @project_uniq = (@user.projects + @projects).uniq
    @user.projects = @project_uniq
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
      puts params.inspect
      params.fetch(:user, :id, :projects_id)
    end
end
