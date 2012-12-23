require 'spec_helper'

describe "downloaded_data/show" do
  before(:each) do
    @downloaded_datum = assign(:downloaded_datum, stub_model(DownloadedDatum,
      :name => "Name",
      :data => "Data",
      :annotation => "Annotation"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Data/)
    rendered.should match(/Annotation/)
  end
end
