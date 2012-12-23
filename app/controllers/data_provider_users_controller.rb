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
end
