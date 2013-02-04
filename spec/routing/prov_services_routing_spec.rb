require "spec_helper"

describe ProvServicesController do
  describe "routing" do

    it "routes to #index" do
      get("/prov_services").should route_to("prov_services#index")
    end

    it "routes to #new" do
      get("/prov_services/new").should route_to("prov_services#new")
    end

    it "routes to #show" do
      get("/prov_services/1").should route_to("prov_services#show", :id => "1")
    end

    it "routes to #edit" do
      get("/prov_services/1/edit").should route_to("prov_services#edit", :id => "1")
    end

    it "routes to #create" do
      post("/prov_services").should route_to("prov_services#create")
    end

    it "routes to #update" do
      put("/prov_services/1").should route_to("prov_services#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/prov_services/1").should route_to("prov_services#destroy", :id => "1")
    end

  end
end
