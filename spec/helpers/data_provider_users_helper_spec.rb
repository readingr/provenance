require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DataProviderUsersHelper. For example:
#
# describe DataProviderUsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe DataProviderUsersHelper do

	describe "update_link" do
		it "should return the correct link for facebook" do
			dpu = Factory.create(:data_provider_user)
			dp = Factory.create(:data_provider)
			dpu.data_provider_id = dp.id
			dpu.save


			helper.update_link(dpu).should eq("<td><a href=\"/data_provider_users/#{dpu.id.to_s}/update_data\">Update</a></td>")
		end


		it "should return the correct link for facebook" do
			dpu = Factory.create(:data_provider_user)
			dp = Factory.create(:data_provider)
			dp.name = "Twitter"
			dp.save

			dpu.data_provider_id = dp.id
			dpu.save


			helper.update_link(dpu).should eq("<td><a href=\"/data_provider_users/#{dpu.id.to_s}/update_data\">Update</a></td>")
		end

		it "should panic" do
			dpu = Factory.create(:data_provider_user)
			dp = Factory.create(:data_provider)
			dp.name = "MEOW"
			dp.save

			dpu.data_provider_id = dp.id
			dpu.save


			helper.update_link(dpu).should eq(nil)
		end
	end

	describe "last_updated_time" do

		it "should return N/A where no Downloaded Datum" do
			dpu = Factory.create(:data_provider_user)
			helper.last_updated_time(dpu).should eq("<td>N/A</td>")
		end


		it "should return the latest updated time" do
			dpu = Factory.create(:data_provider_user)
			dd = Factory.create(:downloaded_datum)
			dd.data_provider_user_id = dpu.id
			dd.save

			helper.last_updated_time(dpu).should eq("<td> #{dpu.downloaded_datum.last.updated_at} </td>")
		end
	end

end
