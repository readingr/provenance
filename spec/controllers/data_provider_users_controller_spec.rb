require 'spec_helper'

describe DataProviderUsersController do
  

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
  # DataProviderUser. As you add validations to DataProviderUser, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {"user_id" => @user.id}
  end


  describe "GET index" do
    it "assigns all data_provider_users as @data_provider_users" do
      get :index
      assigns(:data_provider_users).should eq([@data_provider_user])
    end
  end

  describe "GET show" do
    it "assigns the requested data_provider_user as @data_provider_user" do
      get :show, {:id => @data_provider_user.to_param}
      assigns(:data_provider_user).should eq(@data_provider_user)
    end
  end

  describe "GET new" do
    it "assigns a new data_provider_user as @data_provider_user" do
      get :new
      assigns(:data_provider_user).should be_a_new(DataProviderUser)
    end
  end

  describe "GET edit" do
    it "assigns the requested data_provider_user as @data_provider_user" do
      get :edit, {:id => @data_provider_user.to_param}
      assigns(:data_provider_user).should eq(@data_provider_user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DataProviderUser" do
        expect {
          post :create, {:data_provider_user => valid_attributes}
        }.to change(DataProviderUser, :count).by(1)
      end

      it "assigns a newly created data_provider_user as @data_provider_user" do
        post :create, {:data_provider_user => valid_attributes}
        assigns(:data_provider_user).should be_a(DataProviderUser)
        assigns(:data_provider_user).should be_persisted
      end

      it "redirects to the created data_provider_user" do
        post :create, {:data_provider_user => valid_attributes}
        response.should redirect_to(login_data_provider_user_path(@user.data_provider_users.last.id))
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested data_provider_user" do
        data_provider_user = DataProviderUser.create! valid_attributes
        # Assuming there are no other data_provider_users in the database, this
        # specifies that the DataProviderUser created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DataProviderUser.any_instance.should_receive(:update_attributes).with({ "user_id" => "1" })
        put :update, {:id => data_provider_user.to_param, :data_provider_user => { "user_id" => "1" }}
      end

      it "assigns the requested data_provider_user as @data_provider_user" do
        data_provider_user = DataProviderUser.create! valid_attributes
        put :update, {:id => data_provider_user.to_param, :data_provider_user => valid_attributes}
        assigns(:data_provider_user).should eq(data_provider_user)
      end

      it "redirects to the data_provider_user" do
        data_provider_user = DataProviderUser.create! valid_attributes
        put :update, {:id => data_provider_user.to_param, :data_provider_user => valid_attributes}
        response.should redirect_to(data_provider_user)
      end
    end

    describe "with invalid params" do
      it "assigns the data_provider_user as @data_provider_user" do
        # data_provider_user = DataProviderUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DataProviderUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => @data_provider_user.to_param, :data_provider_user => { "user_id" => "invalid value" }}
        assigns(:data_provider_user).should eq(@data_provider_user)
      end

      it "re-renders the 'edit' template" do
        # data_provider_user = DataProviderUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DataProviderUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => @data_provider_user.to_param, :data_provider_user => { "user_id" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested data_provider_user" do
      expect {
        delete :destroy, {:id => @data_provider_user.to_param}
      }.to change(DataProviderUser, :count).by(-1)
    end

    it "redirects to the data_provider_users list" do
      delete :destroy, {:id => @data_provider_user.to_param}
      response.should redirect_to(data_provider_users_url)
    end
  end

  describe "GET login" do
    describe "Facebook" do
      it "should render the login page" do
        get :login, {id: @data_provider_user.id}
        response.should render_template("login")
      end
    end

    describe "Twitter" do
      before(:each) do
        @data_provider.name = "Twitter"
        @data_provider.save

        @consumer = OAuth::Consumer.new("fYuL73SIEuhw6kgNvs2hA", "49ujIlgckdjJGbuKV8IafH9rKuvO6PlSCuxEVspd4", {:site=> "http://api.twitter.com"} )

        @token = OAuth::RequestToken.new(@consumer, "186553918-sEAEO2fcvtyO1x99eH4Q4XwVcOYatODCQ5f1TwqD", "gLw2PtUyTZfxIan1gJBnbP7icboXbi98KlUoOn7ycVs") 
        require 'TwitterOauth'
        TwitterOauth.stub(:request_url).and_return(@token)

      end

      it "should update the tokens" do
        get :login, {id: @data_provider_user.id}
        @data_provider_user.reload
        @data_provider_user.access_token.should_not eq(nil)
        @data_provider_user.oauth_token_secret.should_not eq(nil)
      end

      it "should not render the login page" do
        get :login, {id: @data_provider_user.id}
        response.should_not render_template("login")
      end

      it "should redirect to the twitter url" do
        get :login, {id: @data_provider_user.id}
        response.should redirect_to(@token.authorize_url)
      end
    end
  end

  describe "Twitter_Oauth" do
    before (:each) do
      @data_provider.name = "Twitter"
      @data_provider.save

      @token = OAuth::RequestToken.new(@consumer, "186553918-sEAEO2fcvtyO1x99eH4Q4XwVcOYatODCQ5f1TwqD", "gLw2PtUyTZfxIan1gJBnbP7icboXbi98KlUoOn7ycVs") 
      require 'TwitterOauth'

      @access_token = OAuth::AccessToken.new(@consumer, "some-access-token", "some-token-secret")

      TwitterOauth.stub(:request_url).and_return(@token)
    end

    it "should update access_token and oauth_token_secret" do
      OAuth::RequestToken.any_instance.stub(:get_access_token).and_return(@access_token)
      get :twitter_oauth

      @data_provider_user.reload
      @data_provider_user.access_token.should eq(@access_token.token)
      @data_provider_user.oauth_token_secret.should eq(@access_token.secret)
    end

    it "should redirect to data_provider_users path" do
      OAuth::RequestToken.any_instance.stub(:get_access_token).and_return(@access_token)
      get :twitter_oauth
      response.should redirect_to data_provider_users_path
    end

    it "should raise an error if token is nil" do
      OAuth::RequestToken.any_instance.stub(:get_access_token).and_return(nil)
      expect {get :twitter_oauth}.to raise_error
    end
  end


  describe "update_data" do

    it "should call update facebook" do
        DataProviderUser.any_instance.stub(:update_facebook).and_return(Factory.create(:downloaded_datum))

        get :update_data, {id: @data_provider_user.id}

        response.should redirect_to generate_provenance_data_provider_user_downloaded_datum_path(@data_provider_user.id, DownloadedDatum.last.id)

    end

    it "should call update twitter" do
        DataProviderUser.any_instance.stub(:update_twitter).and_return(Factory.create(:downloaded_datum))
        @data_provider = Factory.create(:data_provider)
        @data_provider.name = "Twitter"
        @data_provider.save

        @data_provider_user.data_provider_id = @data_provider.id
        @data_provider_user.save 

        get :update_data, {id: @data_provider_user.id}

        response.should redirect_to generate_provenance_data_provider_user_downloaded_datum_path(@data_provider_user.id, DownloadedDatum.last.id)
        
    end

    it "should call non-existent method" do
        @data_provider = Factory.create(:data_provider)
        @data_provider.name = "LOL"
        @data_provider.save

        @data_provider_user.data_provider_id = @data_provider.id
        @data_provider_user.save 

        expect{
          get :update_data, {id: @data_provider_user.id}
        }.to raise_error
    end
  end

  describe "facebook_get_oauth_token" do
  
    it "should get the token" do 
      stub_request(:any, /.*facebook.*/).to_return(:body => "access_token=AAAEY0v0jygwBACsjLXalh4hq6WypFcMh3u68eAb5ddjV02CCnBrdixwTAPHXSyJzGDZAiAr1IsTGW0011qmWQoSJgGmBuA2D6We4NvAZDZD&expires=5180614")

      get :facebook_get_oauth_token, {id: @data_provider_user.id, access_token: "someAccessToken", uid: "someUID"}  

      @data_provider_user.reload

      @data_provider_user.uid.should eq("someUID")
      @data_provider_user.access_token.should eq("AAAEY0v0jygwBACsjLXalh4hq6WypFcMh3u68eAb5ddjV02CCnBrdixwTAPHXSyJzGDZAiAr1IsTGW0011qmWQoSJgGmBuA2D6We4NvAZDZD")
    end

    it "should redirect" do 
      stub_request(:any, /.*facebook.*/).to_return(:body => "access_token=AAAEY0v0jygwBACsjLXalh4hq6WypFcMh3u68eAb5ddjV02CCnBrdixwTAPHXSyJzGDZAiAr1IsTGW0011qmWQoSJgGmBuA2D6We4NvAZDZD&expires=5180614")

      get :facebook_get_oauth_token, {id: @data_provider_user.id, access_token: "someAccessToken", uid: "someUID"}  

      response.should redirect_to data_provider_users_url
    end

    it "should raise error due to incorrect token" do 
      stub_request(:any, /.*facebook.*/).to_return(:body => "acAAAEY0v0jygwBACsjLXalh4hq6WypFcMh3u68eAb5ddjV02CCnBrdixwTAPHXSyJzGDZAiAr1IsTGW0011qmWQoSJgGmBuA2D6We4NvAZ")

     expect{
      get :facebook_get_oauth_token, {id: @data_provider_user.id, access_token: "someAccessToken", uid: "someUID"} 
      }.to raise_error
    end

    it "should raise error due to no uid" do 
      stub_request(:any, /.*facebook.*/).to_return(:body => "access_token=AAAEY0v0jygwBACsjLXalh4hq6WypFcMh3u68eAb5ddjV02CCnBrdixwTAPHXSyJzGDZAiAr1IsTGW0011qmWQoSJgGmBuA2D6We4NvAZDZD&expires=5180614")

     expect{
      get :facebook_get_oauth_token, {id: @data_provider_user.id, access_token: "someAccessToken", uid: nil} 
      }.to raise_error
    end

    it "should raise error due to no uid" do 
      stub_request(:any, /.*facebook.*/).to_return(:body => "access_token=AAAEY0v0jygwBACsjLXalh4hq6WypFcMh3u68eAb5ddjV02CCnBrdixwTAPHXSyJzGDZAiAr1IsTGW0011qmWQoSJgGmBuA2D6We4NvAZDZD&expires=5180614")

     expect{
      get :facebook_get_oauth_token, {id: @data_provider_user.id, access_token: nil, uid: "someUID"} 
      }.to raise_error
    end
  end
end
