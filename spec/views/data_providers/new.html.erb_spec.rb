require 'spec_helper'

describe "data_providers/new" do
  before(:each) do
    assign(:data_provider, stub_model(DataProvider,
      :name => "MyString",
      :url => "MyString"
    ).as_new_record)
  end

  it "renders new data_provider form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => data_providers_path, :method => "post" do
      assert_select "input#data_provider_name", :name => "data_provider[name]"
      assert_select "input#data_provider_url", :name => "data_provider[url]"
    end
  end
end
