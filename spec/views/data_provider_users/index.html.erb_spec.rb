require 'spec_helper'

describe "data_provider_users/index" do
  before(:each) do
    assign(:data_provider_users, [
      stub_model(DataProviderUser,
        :user_id => 1,
        :data_provider_id => 2,
        :username => "Username",
        :password => "Password"
      ),
      stub_model(DataProviderUser,
        :user_id => 1,
        :data_provider_id => 2,
        :username => "Username",
        :password => "Password"
      )
    ])
  end

  it "renders a list of data_provider_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
  end
end
