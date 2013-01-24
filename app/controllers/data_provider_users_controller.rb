class DataProviderUsersController < ApplicationController

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




  def login
    @data_provider_user = DataProviderUser.find(params[:id])

  end

  def update_facebook
    # puts "*******************************************"
    
    @data_provider_user = DataProviderUser.find(params[:id])
   

#This is an alternative way of doing it.

    # require 'net/http'
    # require 'uri'

    # uri = URI.parse("https://api.facebook.com/method/fql.query")

    # param = {'query'=> 'SELECT first_name, last_name, profile_url, sex, pic_small, about_me, friend_count, inspirational_people, username FROM user WHERE uid = 1144492288', 'format' =>'json', 'access_token'=> @data_provider_user.access_token}

    # # debugger
    # http = Net::HTTP.new(uri.host, uri.port) 
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # request = Net::HTTP::Get.new(uri.path) 
    # request.set_form_data( param )

    # # instantiate a new Request object
    # request = Net::HTTP::Get.new( uri.path+ '?' + request.body ) 

    # response = http.request(request)


    # debugger
    #validation needed here if there is no facebook login.    
    options = { :access_token => @data_provider_user.access_token, :format => 'json' }
    query = Fql.execute({"query1" => 'SELECT first_name, last_name, profile_url, sex, pic_small, about_me, friend_count, inspirational_people, username FROM user WHERE uid = 1144492288'}, options)
    results = (query[0].values[1])[0]

    json_results = results.to_json
    # debugger

    # puts results

    @downloaded_datum = DownloadedDatum.new(name: "Facebook", data: json_results, data_provider_user_id: @data_provider_user.id)


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



  def facebook_get_oauth_token

    require 'net/http'
    require 'uri'

    uri = URI.parse("https://graph.facebook.com/oauth/access_token")

    param = {'grant_type'=> 'fb_exchange_token', 'client_id' =>'308769445890556', 'client_secret'=>'acf570bff4de2f66da870a58d8116f47', 'fb_exchange_token'=> params[:access_token]}

    # debugger
    http = Net::HTTP.new(uri.host, uri.port) 
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.path) 
    request.set_form_data( param )

    # instantiate a new Request object
    request = Net::HTTP::Get.new( uri.path+ '?' + request.body ) 

    response = http.request(request)
    # puts "***************"
    # puts response.body
    # puts "***************"

    token = response.body.match(/=(.*)&e/)[1]

    # @data_provider_user = DataProviderUser.find(current_user.data_provider_users.first.id);
    @data_provider_user = DataProviderUser.find(params[:id])
    @data_provider_user.access_token = token
    @data_provider_user.save


    respond_to do |format|
      format.html { redirect_to data_provider_users_url }
      format.json { head :no_content }
    end
  end

end
