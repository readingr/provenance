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

        @consumer = OAuth::Consumer.new("fYuL73SIEuhw6kgNvs2hA", "49ujIlgckdjJGbuKV8IafH9rKuvO6PlSCuxEVspd4", {:site=> "http://twitter.com"} )

        @token = OAuth::RequestToken.new(@consumer, "186553918-sEAEO2fcvtyO1x99eH4Q4XwVcOYatODCQ5f1TwqD", "gLw2PtUyTZfxIan1gJBnbP7icboXbi98KlUoOn7ycVs") 

      end

      it "should update the tokens" do
        require 'TwitterOauth'
        TwitterOauth.stub(:request_url).and_return(@token)

        get :login, {id: @data_provider_user.id}
        @data_provider_user.reload
        @data_provider_user.access_token.should_not eq(nil)
        @data_provider_user.oauth_token_secret.should_not eq(nil)
      end

      it "should not render the login page" do
        require 'TwitterOauth'

        TwitterOauth.stub(:request_url).and_return(@token)

        get :login, {id: @data_provider_user.id}
        response.should_not render_template("login")
      end
    end
  end

end
