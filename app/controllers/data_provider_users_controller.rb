class DataProviderUsersController < ApplicationController
  load_and_authorize_resource

  # GET /data_provider_users
  # GET /data_provider_users.json
  def index
    @data_provider_users = DataProviderUser.where(user_id: current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data_provider_users }
    end
  end

  # GET /data_provider_users/1
  # GET /data_provider_users/1.json
  def show
    @data_provider_user = DataProviderUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @data_provider_user }
    end
  end

  # GET /data_provider_users/new
  # GET /data_provider_users/new.json
  def new
    @data_provider_user = DataProviderUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @data_provider_user }
    end
  end

  # GET /data_provider_users/1/edit
  def edit
    @data_provider_user = DataProviderUser.find(params[:id])
  end

  # POST /data_provider_users
  # POST /data_provider_users.json
  def create
    @data_provider_user = DataProviderUser.new(params[:data_provider_user])
    @data_provider_user.user_id = current_user.id #this associates the given data_provider_user with the user that's creating it.

    respond_to do |format|
      if @data_provider_user.save
        format.html { redirect_to login_data_provider_user_path(@data_provider_user), notice: 'Data provider user was successfully created.' }
        format.json { render json: @data_provider_user, status: :created, location: @data_provider_user }
      else
        format.html { render action: "new" }
        format.json { render json: @data_provider_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /data_provider_users/1
  # PUT /data_provider_users/1.json
  def update

    @data_provider_user = DataProviderUser.find(params[:id])

    respond_to do |format|
      if @data_provider_user.update_attributes(params[:data_provider_user])
        format.html { redirect_to @data_provider_user, notice: 'Data provider user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @data_provider_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_provider_users/1
  # DELETE /data_provider_users/1.json
  def destroy
    @data_provider_user = DataProviderUser.find(params[:id])
    @data_provider_user.destroy

    respond_to do |format|
      format.html { redirect_to data_provider_users_url }
      format.json { head :no_content }
    end
  end



  #this provides the login page
  #it renders the login page from the view.
  def login
    require 'TwitterOauth'
    @data_provider_user = DataProviderUser.find(params[:id])

    if @data_provider_user.twitter?

      @request_token = TwitterOauth.request_url

      @data_provider_user.access_token = @request_token.token
      @data_provider_user.oauth_token_secret = @request_token.secret
      
      if @data_provider_user.save!
        redirect_to @request_token.authorize_url              
      end      

    end
  end

  def twitter_oauth
    require 'TwitterOauth'

    @data_provider_user = current_user.data_provider_users.last

    request_token = TwitterOauth.request_token(@data_provider_user.access_token, @data_provider_user.oauth_token_secret)
    
    @access_token = request_token.get_access_token(:oauth_verifier =>  params[:oauth_verifier] )

    if !@access_token.nil?
      @data_provider_user.access_token = @access_token.token
      @data_provider_user.oauth_token_secret = @access_token.secret
    else
      raise "Access Token Nil"
    end
    respond_to do |format|
      if @data_provider_user.save
        format.html { redirect_to data_provider_users_path, notice: 'Data provider user was successfully created.' }
        format.json { render json: @data_provider_user, status: :created, location: @data_provider_user }
      else
        format.html { render action: "new" }
        format.json { render json: @data_provider_user.errors, status: :unprocessable_entity }
      end
    end
  end


  #this method receives the update frequency and sets it for the cron job
  def update_frequency
    @data_provider_user = DataProviderUser.find(params[:id])
  end



  def update_data

    @data_provider_user = DataProviderUser.find(params[:id])
   

    @downloaded_datum = @data_provider_user.determine_update


    respond_to do |format|
      if @downloaded_datum.save
        format.html { redirect_to generate_provenance_data_provider_user_downloaded_datum_path(@data_provider_user.id, @downloaded_datum.id), notice: 'Downloaded datum was successfully created.' }
        format.json { render json: @downloaded_datum, status: :created, location: @downloaded_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @downloaded_datum.errors, status: :unprocessable_entity }
      end
    end   
  end


#this gets the initial access token (is it really oauth??) and extends it for 60 days.
  def facebook_get_oauth_token

    require 'net/http'
    require 'uri'

    uri = URI.parse("https://graph.facebook.com/oauth/access_token")

    if !params[:access_token].nil?
    param = {'grant_type'=> 'fb_exchange_token', 'client_id' =>'308769445890556', 'client_secret'=>'acf570bff4de2f66da870a58d8116f47', 'fb_exchange_token'=> params[:access_token]}
    else
      raise "Access Token nil"
    end
    
    http = Net::HTTP.new(uri.host, uri.port) 
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.path) 
    request.set_form_data( param )

    # instantiate a new Request object
    request = Net::HTTP::Get.new( uri.path+ '?' + request.body ) 

    response = http.request(request)
    token = response.body.match(/=(.*)&e/)[1]

    @data_provider_user = DataProviderUser.find(params[:id])
    if !params[:uid].nil?
      @data_provider_user.uid = params[:uid]
    else
      raise "UID nil"
    end
    @data_provider_user.access_token = token
    @data_provider_user.save


    respond_to do |format|
      format.html { redirect_to data_provider_users_url }
      format.json { head :no_content }
    end
  end


  #this gets the overall provenance of the system, collates it into one bundle and sends it to the prov server
  def overall_prov
    url = current_user.overall_prov

    respond_to do |format| 
      if !url.nil?
        format.html {redirect_to url }
        format.json { head :no_content }
      else
      format.html { redirect_to data_provider_users_url }
      format.json { head :no_content }
    end
    end
  end

end
