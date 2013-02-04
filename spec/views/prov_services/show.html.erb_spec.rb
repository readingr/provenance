require 'spec_helper'

describe "prov_services/show" do
  before(:each) do
    @prov_service = assign(:prov_service, stub_model(ProvService,
      :username => "Username",
      :access_token => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Username/)
    rendered.should match(/MyText/)
  end
end
