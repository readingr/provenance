require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe DataProviderUsersController do

  # This should return the minimal set of attributes required to create a valid
  # DataProviderUser. As you add validations to DataProviderUser, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "user_id" => "1" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DataProviderUsersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all data_provider_users as @data_provider_users" do
      data_provider_user = DataProviderUser.create! valid_attributes
      get :index, {}, valid_session
      assigns(:data_provider_users).should eq([data_provider_user])
    end
  end

  describe "GET show" do
    it "assigns the requested data_provider_user as @data_provider_user" do
      data_provider_user = DataProviderUser.create! valid_attributes
      get :show, {:id => data_provider_user.to_param}, valid_session
      assigns(:data_provider_user).should eq(data_provider_user)
    end
  end

  describe "GET new" do
    it "assigns a new data_provider_user as @data_provider_user" do
      get :new, {}, valid_session
      assigns(:data_provider_user).should be_a_new(DataProviderUser)
    end
  end

  describe "GET edit" do
    it "assigns the requested data_provider_user as @data_provider_user" do
      data_provider_user = DataProviderUser.create! valid_attributes
      get :edit, {:id => data_provider_user.to_param}, valid_session
      assigns(:data_provider_user).should eq(data_provider_user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DataProviderUser" do
        expect {
          post :create, {:data_provider_user => valid_attributes}, valid_session
        }.to change(DataProviderUser, :count).by(1)
      end

      it "assigns a newly created data_provider_user as @data_provider_user" do
        post :create, {:data_provider_user => valid_attributes}, valid_session
        assigns(:data_provider_user).should be_a(DataProviderUser)
        assigns(:data_provider_user).should be_persisted
      end

      it "redirects to the created data_provider_user" do
        post :create, {:data_provider_user => valid_attributes}, valid_session
        response.should redirect_to(DataProviderUser.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved data_provider_user as @data_provider_user" do
        # Trigger the behavior that occurs when invalid params are submitted
        DataProviderUser.any_instance.stub(:save).and_return(false)
        post :create, {:data_provider_user => { "user_id" => "invalid value" }}, valid_session
        assigns(:data_provider_user).should be_a_new(DataProviderUser)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DataProviderUser.any_instance.stub(:save).and_return(false)
        post :create, {:data_provider_user => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("new")
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
        put :update, {:id => data_provider_user.to_param, :data_provider_user => { "user_id" => "1" }}, valid_session
      end

      it "assigns the requested data_provider_user as @data_provider_user" do
        data_provider_user = DataProviderUser.create! valid_attributes
        put :update, {:id => data_provider_user.to_param, :data_provider_user => valid_attributes}, valid_session
        assigns(:data_provider_user).should eq(data_provider_user)
      end

      it "redirects to the data_provider_user" do
        data_provider_user = DataProviderUser.create! valid_attributes
        put :update, {:id => data_provider_user.to_param, :data_provider_user => valid_attributes}, valid_session
        response.should redirect_to(data_provider_user)
      end
    end

    describe "with invalid params" do
      it "assigns the data_provider_user as @data_provider_user" do
        data_provider_user = DataProviderUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DataProviderUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => data_provider_user.to_param, :data_provider_user => { "user_id" => "invalid value" }}, valid_session
        assigns(:data_provider_user).should eq(data_provider_user)
      end

      it "re-renders the 'edit' template" do
        data_provider_user = DataProviderUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DataProviderUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => data_provider_user.to_param, :data_provider_user => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested data_provider_user" do
      data_provider_user = DataProviderUser.create! valid_attributes
      expect {
        delete :destroy, {:id => data_provider_user.to_param}, valid_session
      }.to change(DataProviderUser, :count).by(-1)
    end

    it "redirects to the data_provider_users list" do
      data_provider_user = DataProviderUser.create! valid_attributes
      delete :destroy, {:id => data_provider_user.to_param}, valid_session
      response.should redirect_to(data_provider_users_url)
    end
  end

end