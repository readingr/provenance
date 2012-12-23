require 'spec_helper'

describe "data_provider_users/show" do
  before(:each) do
    @data_provider_user = assign(:data_provider_user, stub_model(DataProviderUser,
      :user_id => 1,
      :data_provider_id => 2,
      :username => "Username",
      :password => "Password"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Username/)
    rendered.should match(/Password/)
  end
end
