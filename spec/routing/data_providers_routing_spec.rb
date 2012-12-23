require "spec_helper"

describe DataProvidersController do
  describe "routing" do

    it "routes to #index" do
      get("/data_providers").should route_to("data_providers#index")
    end

    it "routes to #new" do
      get("/data_providers/new").should route_to("data_providers#new")
    end

    it "routes to #show" do
      get("/data_providers/1").should route_to("data_providers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/data_providers/1/edit").should route_to("data_providers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/data_providers").should route_to("data_providers#create")
    end

    it "routes to #update" do
      put("/data_providers/1").should route_to("data_providers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/data_providers/1").should route_to("data_providers#destroy", :id => "1")
    end

  end
end
