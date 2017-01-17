class OwnersController < ApplicationController
  before_action :set_owner, only: [:show, :update, :destroy]

  # GET /owners
  def index
    @owners = Owner.filter(params.slice(:n, :email, :acme_id, :contains, :starts_with))
    render json: @owners
  end

  # GET /owners/1
  def show
    if @owner.nil?
      render :head => true, :status => :not_found
    else
      render json: @owner
    end
  end

  # POST /owners
  def create
    @owner = Owner.new(owner_params)

    if @owner.save
      render json: @owner, status: :created, location: @owner
    else
      render json: @owner.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /owners/1
  def update
    if @owner.update(owner_params)
      render json: @owner
    else
      render json: @owner.errors, status: :unprocessable_entity
    end
  end

  # DELETE /owners/1
  def destroy
    @owner.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_owner
      begin
        @owner = Owner.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @owner = nil
      end
    end

    # Only allow a trusted parameter "white list" through.
    def owner_params
      params.require(:owner).permit(:name, :email, :pkcs12, :detail, :acme_id)
    end
end
