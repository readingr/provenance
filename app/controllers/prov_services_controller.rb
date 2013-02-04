class ProvServicesController < ApplicationController
  # GET /prov_services
  # GET /prov_services.json
  def index
    @prov_services = ProvService.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prov_services }
    end
  end

  # GET /prov_services/1
  # GET /prov_services/1.json
  def show
    @prov_service = ProvService.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prov_service }
    end
  end

  # GET /prov_services/new
  # GET /prov_services/new.json
  def new
    @prov_service = ProvService.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prov_service }
    end
  end

  # GET /prov_services/1/edit
  def edit
    @prov_service = ProvService.find(params[:id])
  end

  # POST /prov_services
  # POST /prov_services.json
  def create
    @prov_service = ProvService.new(params[:prov_service])

    respond_to do |format|
      if @prov_service.save
        format.html { redirect_to @prov_service, notice: 'Prov service was successfully created.' }
        format.json { render json: @prov_service, status: :created, location: @prov_service }
      else
        format.html { render action: "new" }
        format.json { render json: @prov_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prov_services/1
  # PUT /prov_services/1.json
  def update
    @prov_service = ProvService.find(params[:id])

    respond_to do |format|
      if @prov_service.update_attributes(params[:prov_service])
        format.html { redirect_to @prov_service, notice: 'Prov service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prov_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prov_services/1
  # DELETE /prov_services/1.json
  def destroy
    @prov_service = ProvService.find(params[:id])
    @prov_service.destroy

    respond_to do |format|
      format.html { redirect_to prov_services_url }
      format.json { head :no_content }
    end
  end
end
