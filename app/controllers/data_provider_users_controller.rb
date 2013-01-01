class DataProviderUsersController < ApplicationController
  # GET /data_provider_users
  # GET /data_provider_users.json
  def index
    @data_provider_users = DataProviderUser.all

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
    @data_provider_user.user_id = current_user #this associates the given data_provider_user with the user that's creating it.

    respond_to do |format|
      if @data_provider_user.save
        format.html { redirect_to @data_provider_user, notice: 'Data provider user was successfully created.' }
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

  def update_facebook
    puts "*******************************************"
    
    @data_provider_user = DataProviderUser.find(params[:id])
    
    # debugger
    #validation needed here if there is no facebook login.    
    options = { :access_token => @data_provider_user.access_token }
    query = Fql.execute({"query1" => 'SELECT first_name, last_name, profile_url, sex, pic_small, about_me, friend_count, inspirational_people, username FROM user WHERE uid = 1144492288'}, options)
    results = (query[0].values[1])[0]

    json_results = results.to_json
    debugger

    puts results

    respond_to do |format|
      format.html { redirect_to data_provider_users_url }
      format.json { head :no_content }
    end
  end

  def facebook_oauth
    # debugger
    #this will be needed in the future https://developers.facebook.com/docs/howtos/login/extending-tokens/

    client = OAuth2::Client.new('308769445890556', 'acf570bff4de2f66da870a58d8116f47', :site => 'https://graph.facebook.com')
    token = OAuth2::AccessToken.new client, params[:access_token]
    token.get('/me')
    @data_provider_user = DataProviderUser.find(current_user.data_provider_users.first.id);
    @data_provider_user.access_token = token.token
    @data_provider_user.save
    # debugger

    respond_to do |format|
      format.html { redirect_to data_provider_users_url }
      format.json { head :no_content }
    end
  end

end
