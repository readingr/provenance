require 'spec_helper'

describe "prov_services/edit" do
  before(:each) do
    @prov_service = assign(:prov_service, stub_model(ProvService,
      :username => "MyString",
      :access_token => "MyText"
    ))
  end

  it "renders the edit prov_service form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => prov_services_path(@prov_service), :method => "post" do
      assert_select "input#prov_service_username", :name => "prov_service[username]"
      assert_select "textarea#prov_service_access_token", :name => "prov_service[access_token]"
    end
  end
end
