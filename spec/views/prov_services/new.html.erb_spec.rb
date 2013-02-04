require 'spec_helper'

describe "prov_services/new" do
  before(:each) do
    assign(:prov_service, stub_model(ProvService,
      :username => "MyString",
      :access_token => "MyText"
    ).as_new_record)
  end

  it "renders new prov_service form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => prov_services_path, :method => "post" do
      assert_select "input#prov_service_username", :name => "prov_service[username]"
      assert_select "textarea#prov_service_access_token", :name => "prov_service[access_token]"
    end
  end
end
