class EnvironmentsController < ApplicationController
  before_action :set_environment, only: [:show, :update, :destroy]

  # GET /environments
  def index
    @environments = Environment.all

    render json: @environments
  end

  # GET /environments/1
  def show
    render json: @environment
  end

  # POST /environments
  def create
    @environment = Environment.new(environment_params)

    if @environment.save
      render json: @environment, status: :created, location: @environment
    else
      render json: @environment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /environments/1
  def update
    if @environment.update(environment_params)
      render json: @environment
    else
      render json: @environment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /environments/1
  def destroy
    @environment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_environment
      @environment = Environment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def environment_params
      params.require(:environment).permit(:name, :destination_crt)
    end
end
