require 'spec_helper'

describe "DataProviders" do
  describe "GET /data_providers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get data_providers_path
      response.status.should be(200)
    end
  end
end
