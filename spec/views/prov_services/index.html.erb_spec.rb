require 'spec_helper'

describe "prov_services/index" do
  before(:each) do
    assign(:prov_services, [
      stub_model(ProvService,
        :username => "Username",
        :access_token => "MyText"
      ),
      stub_model(ProvService,
        :username => "Username",
        :access_token => "MyText"
      )
    ])
  end

  it "renders a list of prov_services" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
