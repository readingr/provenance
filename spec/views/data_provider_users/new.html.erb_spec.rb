require 'spec_helper'

describe "data_provider_users/new" do
  before(:each) do
    assign(:data_provider_user, stub_model(DataProviderUser,
      :user_id => 1,
      :data_provider_id => 1,
      :username => "MyString",
      :password => "MyString"
    ).as_new_record)
  end

  it "renders new data_provider_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => data_provider_users_path, :method => "post" do
      assert_select "input#data_provider_user_user_id", :name => "data_provider_user[user_id]"
      assert_select "input#data_provider_user_data_provider_id", :name => "data_provider_user[data_provider_id]"
      assert_select "input#data_provider_user_username", :name => "data_provider_user[username]"
      assert_select "input#data_provider_user_password", :name => "data_provider_user[password]"
    end
  end
end
