require 'spec_helper'

describe "DownloadedData" do
  describe "GET /downloaded_data" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get downloaded_data_path
      response.status.should be(200)
    end
  end
end
