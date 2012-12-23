require 'spec_helper'

describe "downloaded_data/index" do
  before(:each) do
    assign(:downloaded_data, [
      stub_model(DownloadedDatum,
        :name => "Name",
        :data => "Data",
        :annotation => "Annotation"
      ),
      stub_model(DownloadedDatum,
        :name => "Name",
        :data => "Data",
        :annotation => "Annotation"
      )
    ])
  end

  it "renders a list of downloaded_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Data".to_s, :count => 2
    assert_select "tr>td", :text => "Annotation".to_s, :count => 2
  end
end
