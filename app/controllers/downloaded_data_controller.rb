class DownloadedDataController < ApplicationController
  load_and_authorize_resource

  # load_and_authorize_resource :data_provider_user
  # load_and_authorize_resource :downloaded_data, :through => :data_provider_user

  # GET /downloaded_data
  # GET /downloaded_data.json
  def index
    @downloaded_data = DownloadedDatum.where(data_provider_user_id: params[:data_provider_user_id]).order("updated_at DESC").page(params[:page]).per(10)
    @all_downloaded_data =  DownloadedDatum.where(data_provider_user_id: params[:data_provider_user_id])
    @data_provider_user = DataProviderUser.find(params[:data_provider_user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @downloaded_data }
    end
  end

  # GET /downloaded_data/1
  # GET /downloaded_data/1.json
  def show
    @downloaded_datum = DownloadedDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @downloaded_datum }
    end
  end

  # GET /downloaded_data/new
  # GET /downloaded_data/new.json
  def new
    @downloaded_datum = DownloadedDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @downloaded_datum }
    end
  end


  # POST /downloaded_data
  # POST /downloaded_data.json
  def create
    @downloaded_datum = DownloadedDatum.new(params[:downloaded_datum])

    respond_to do |format|
      if @downloaded_datum.save
        format.html { redirect_to @downloaded_datum, notice: 'Downloaded datum was successfully created.' }
        format.json { render json: @downloaded_datum, status: :created, location: @downloaded_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @downloaded_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /downloaded_data/1
  # PUT /downloaded_data/1.json
  def update
    @downloaded_datum = DownloadedDatum.find(params[:id])

    respond_to do |format|
      if @downloaded_datum.update_attributes(params[:downloaded_datum])
        format.html { redirect_to @downloaded_datum, notice: 'Downloaded datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @downloaded_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /downloaded_data/1
  # DELETE /downloaded_data/1.json
  def destroy
    @downloaded_datum = DownloadedDatum.find(params[:id])
    @downloaded_datum.destroy

    respond_to do |format|
      format.html { redirect_to data_provider_user_downloaded_data_url }
      format.json { head :no_content }
    end
  end

  #this downloads the data to the user
  def download
    require 'active_support/core_ext/hash/deep_merge'

    @downloaded_datum = DownloadedDatum.find(params[:id])

    prov = {"has_provenance"=>"#{ENV['PROV_SERVER']}/store/bundles/#{@downloaded_datum.prov_id}"}

    data = ActiveSupport::JSON.decode(@downloaded_datum.data).deep_merge(prov)

    send_data data.to_json,
      :type => 'text',
      :disposition => "attachment; filename=#{@downloaded_datum.data_provider_user.data_provider.name+Time.now.to_s}.txt"
  end



  #this generates the provenance for downloaded data
  def generate_provenance
    @downloaded_datum = DownloadedDatum.find(params[:id])
    @downloaded_datum.generate_provenance(false)

    respond_to do |format|
      format.html { redirect_to data_provider_user_downloaded_datum_path(params[:data_provider_user_id], @downloaded_datum.id), notice: 'Downloaded datum was successfully created.' }
      format.json { render json: @downloaded_datum, status: :created, location: @downloaded_datum }
    end   
  end




  #this method is used to get data from the database.
  #this is done so that the JSON diff can retrieve the data and compare it
  def return_data
    @downloaded_datum = DownloadedDatum.find(params[:id])

    respond_to do |format|
      format.json { render json: @downloaded_datum.data}
    end
  end


  def post_micropost


    @downloaded_datum = DownloadedDatum.find(params[:id])
    @data_provider_user = DataProviderUser.find(params[:data_provider_user_id])

    if !@downloaded_datum.prov_id.blank?
      content = "Post made from Web app, Downloaded Data number #{@downloaded_datum.id}"
      has_provenance = ENV['PROV_SERVER']+"/store/bundles/"+@downloaded_datum.prov_id.to_s+".provn"

      require 'net/http'
      uri = URI("http://localhost:3001/users/#{@data_provider_user.uid.to_s}/remote_posting")

      params = {'content' => "Post made from Web app, Downloaded Data number #{@downloaded_datum.id}", 'has_provenance' => has_provenance, 'in_reply_to' => ActiveSupport::JSON.decode(@downloaded_datum.data)['data']['id'], 'bundle_number' => @downloaded_datum.id }

      http = Net::HTTP.new(uri.host, uri.port) 
      request = Net::HTTP::Get.new(uri.path) 

      request.set_form_data( params )

      response = http.request(request)

      respond_to do |format|
        format.html { redirect_to data_provider_user_downloaded_datum_path(@data_provider_user.id, @downloaded_datum.id)}
        format.json { render json: @downloaded_datum, status: :created, location: @downloaded_datum }
      end
    end
  end


end
