class CertificatesController < ApplicationController
  before_action :set_certificate, only: [:show, :update]

  def certificate_url(project)
    "/projects/#{project.id}/certificates"
  end

  # GET /projects/:project_id/certificates
  def index
    begin
      if current_user.admin?
        @certificates = Certificate.joins(:project => :users)
                                   .where(:projects => {:id => params[:project_id]})
                                   .filter(params.slice(:cn, :contains, :starts_with))
      else
        @certificates = Certificate.joins(:project => :users)
                                   .where(:projects => {:id => params[:project_id]})
                                   .where(:users => {:id => current_user.id})
                                   .filter(params.slice(:cn, :contains, :starts_with))
      end
      render json: @certificates
    rescue ActiveRecord::RecordNotFound
      render :head => true, :status => :not_found
    end
  end

  # GET /projects/:project_id/certificates/:id
  def show
    if @certificate.nil?
      render :head => true, :status => :not_found
    else
      render json: @certificate
    end
  end

  # POST /projects/:project_id/certificates
  def create
    @certificate = Certificate.new(certificate_params)
    if @certificate.save
      render json: @certificate, status: :created, location: @certificate
    else
      render json: @certificate.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:project_id/certificates/:id
  def update
    if @certificate.nil?
        render :head => true, :status => :not_found
    else
      if @certificate.update(certificate_params)
        if certificate_params[:revoked]
          send_revoke_certificate
        else
          send_create_certificate
        end
        render json: @certificate
      else
        render json: @certificate.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /projects/:project_id/certificates/:id
  def destroy
    @certificate.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate
      begin
        if current_user.admin?
          @certificate = Certificate.joins(:project => :users)
                                    .where(:projects => {:id => params[:project_id]})
                                    .where(id: params[:id]).first!
        else
          @certificate = Certificate.joins(:project => :users)
                                    .where(:projects => {:id => params[:project_id]})
                                    .where(:users => {:id => current_user.id})
                                    .where(id: params[:id]).first!

        end
      rescue ActiveRecord::RecordNotFound
        @certificate = nil
      end
    end

    # Only allow a trusted parameter "white list" through.
    def certificate_params
      params.require(:certificate).permit(:cn, :last_crt, :csr, :key, :project_id, :revoked, :environment_id, :time_renewal, :auto_renewal)
    end

  private
  def send_create_certificate
    CertificatesCreateJob.perform_later @certificate
  end
  private

  def send_revoke_certificate
    CertificatesRevokeJob.perform_later @certificate
  end
end
