require 'openssl'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.filter(params.slice(:n, :email, :contains, :starts_with))
    render json: @projects
  end

  # GET /projects/1
  def show
    if @project.nil?
      render :head => true, :status => :not_found
    else
      render json: @project
    end
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.private_pem = OpenSSL::PKey::RSA.new(4096).to_pem
    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      begin
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @project = nil
      end
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :email, :pkcs12, :private_pem)
    end
end
