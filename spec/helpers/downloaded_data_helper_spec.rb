require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DownloadedDataHelper. For example:
#
# describe DownloadedDataHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe DownloadedDataHelper do
  # pending "add some examples to (or delete) #{__FILE__}"

  	describe "prov" do

	  	it "should return the correct data" do
			dd = Factory.create(:downloaded_datum)
			dd.prov_id = 1
			dd.save 

		  	helper.prov(dd).should eq("<link rel=\"http://www.w3.org/ns/prov#hasProvenance\" href=\"http://127.0.0.1:8000/store/bundles/1.provn\">\n\t\t<link rel=\"http://www.w3.org/ns/prov#hasAnchor\" href=\"target-URI\">\n\t\t<meta name=\"green-turtle-rdfa-message\">")
	  	end
  	end
end
