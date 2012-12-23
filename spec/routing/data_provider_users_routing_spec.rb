require "spec_helper"

describe DataProviderUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/data_provider_users").should route_to("data_provider_users#index")
    end

    it "routes to #new" do
      get("/data_provider_users/new").should route_to("data_provider_users#new")
    end

    it "routes to #show" do
      get("/data_provider_users/1").should route_to("data_provider_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/data_provider_users/1/edit").should route_to("data_provider_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/data_provider_users").should route_to("data_provider_users#create")
    end

    it "routes to #update" do
      put("/data_provider_users/1").should route_to("data_provider_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/data_provider_users/1").should route_to("data_provider_users#destroy", :id => "1")
    end

  end
end
