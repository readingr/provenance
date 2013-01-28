class UsersController < ApplicationController
  load_and_authorize_resource


  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


  #this creates the provenance when the user logs in and sends it to the store
  def prov_login
    # debugger

    # puts "************************"

    # require 'net/http'
    # require 'uri'

    # uri = URI.parse("https://graph.facebook.com/oauth/access_token")

    # param = {'grant_type'=> 'fb_exchange_token', 'client_id' =>'308769445890556', 'client_secret'=>'acf570bff4de2f66da870a58d8116f47', 'fb_exchange_token'=> params[:access_token]}

    # # debugger
    # http = Net::HTTP.new(uri.host, uri.port) 
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # request = Net::HTTP::Get.new(uri.path) 
    # request.set_form_data( param )

    # # instantiate a new Request object
    # request = Net::HTTP::Get.new( uri.path+ '?' + request.body ) 

    # response = http.request(request)
    # # puts "***************"
    # # puts response.body
    # # puts "***************"

    # token = response.body.match(/=(.*)&e/)[1]

    # # @data_provider_user = DataProviderUser.find(current_user.data_provider_users.first.id);
    # @data_provider_user = DataProviderUser.find(params[:id])
    # @data_provider_user.access_token = token
    # @data_provider_user.save




    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

end
