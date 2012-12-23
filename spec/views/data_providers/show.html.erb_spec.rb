require 'spec_helper'

describe "data_providers/show" do
  before(:each) do
    @data_provider = assign(:data_provider, stub_model(DataProvider,
      :name => "Name",
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Url/)
  end
end
