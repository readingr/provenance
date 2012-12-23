require 'spec_helper'

describe "downloaded_data/edit" do
  before(:each) do
    @downloaded_datum = assign(:downloaded_datum, stub_model(DownloadedDatum,
      :name => "MyString",
      :data => "MyString",
      :annotation => "MyString"
    ))
  end

  it "renders the edit downloaded_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => downloaded_data_path(@downloaded_datum), :method => "post" do
      assert_select "input#downloaded_datum_name", :name => "downloaded_datum[name]"
      assert_select "input#downloaded_datum_data", :name => "downloaded_datum[data]"
      assert_select "input#downloaded_datum_annotation", :name => "downloaded_datum[annotation]"
    end
  end
end
