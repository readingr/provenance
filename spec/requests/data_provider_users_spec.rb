require 'spec_helper'

describe "DataProviderUsers" do
  describe "GET /data_provider_users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get data_provider_users_path
      response.status.should be(200)
    end
  end
end
