require 'spec_helper'

describe DownloadedDataController do


  before (:each) do
      @user = Factory.create(:user)
      sign_in @user

      @data_provider = Factory.create(:data_provider)

      @data_provider_user = Factory.create(:data_provider_user)
      @data_provider_user.user_id = @user.id
      @data_provider_user.data_provider_id = @data_provider.id
      @data_provider_user.save


  end

  # This should return the minimal set of attributes required to create a valid
  # DownloadedDatum. As you add validations to DownloadedDatum, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "name" => "data_provider", "data"=>"{\"status_id\":\"10200694447260623\"}", "data_provider_user_id"=> @data_provider_user.id }
  end



  describe "GET index" do
    it "assigns all downloaded_data as @downloaded_data" do
      downloaded_datum = DownloadedDatum.create! valid_attributes
      get :index, {"data_provider_user_id"=> @data_provider_user.id}
      assigns(:all_downloaded_data).should eq([downloaded_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested downloaded_datum as @downloaded_datum" do
      downloaded_datum = DownloadedDatum.create! valid_attributes
      get :show, {data_provider_user_id:  @data_provider_user.id, :id => downloaded_datum.to_param}
      assigns(:downloaded_datum).should eq(downloaded_datum)
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested downloaded_datum" do
      downloaded_datum = DownloadedDatum.create! valid_attributes
      expect {
        delete :destroy, {data_provider_user_id:  @data_provider_user.id, :id => downloaded_datum.to_param}
      }.to change(DownloadedDatum, :count).by(-1)
    end

    it "redirects to the downloaded_data list" do
      downloaded_datum = DownloadedDatum.create! valid_attributes
      delete :destroy, {data_provider_user_id:  @data_provider_user.id, :id => downloaded_datum.to_param}
      response.should redirect_to(data_provider_user_downloaded_data_path(@data_provider_user.id))
    end
  end

end
