require 'spec_helper'

describe DownloadedDatum do

	it "should have a valid factory" do
		Factory.create(:downloaded_datum).should be_valid
	end


	describe "generate_provenance" do 
		describe "First Download" do
			before(:each) do
				@user = Factory.create(:user)
				
				@dp = Factory.create(:data_provider)
				
				@dpu = Factory.create(:data_provider_user)
				@dpu.data_provider_id = @dp.id
				@dpu.user_id = @user.id
				@dpu.save!

				@dd = Factory.create(:downloaded_datum)
				@dd.data_provider_user_id = @dpu.id
				@dd.save!
				@dd.reload
			end

			it "should return the new bundle" do
				stub_request(:post, /.*127.0.0.1.*/).to_return(:body => '{"id": "135"}')

				@time_now = Time.parse("April 20 2013 15:20:16")
				Time.stub!(:now).and_return(@time_now)

				results = {"wasAttributedTo"=>{"ex:attr#{@dd.id.to_s}"=>{"prov:agent"=>"Test2013-04-20T15:20:16", "prov:entity"=>"Facebook#{@dd.id.to_s}:bundle"}}, "prefix"=>{"ex"=>"http://localhost:3000"}, "entity"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"prov:type"=>"prov:Bundle"}, "ex:Test2013-04-20T15:20:16"=>{}, "Test"=>{}}, "specializationOf"=>{"ex:specTest2013-04-20T15:20:16"=>{"prov:specificEntity"=>"ex:Test2013-04-20T15:20:16", "prov:generalEntity"=>"Test"}}, "bundle"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"entity"=>{"ex:#{@dd.id.to_s}"=>{}, "ex:Facebook"=>{}}, "activity"=>{"ex:download#{@dd.id.to_s}"=>{"startTime"=>["2013-04-20T15:20:16", "xsd:dateTime"], "endTime"=>["2013-04-20T15:20:17", "xsd:dateTime"], "prov:type"=>"Download #{@dd.id.to_s}"}}, "specializationOf"=>{"ex:spec#{@dd.id.to_s}"=>{"prov:specificEntity"=>"ex:#{@dd.id.to_s}", "prov:generalEntity"=>"ex:Facebook"}}, "wasGeneratedBy"=>{"ex:gen#{@dd.id.to_s}"=>{"prov:entity"=>"ex:#{@dd.id.to_s}", "prov:activity"=>"ex:download#{@dd.id.to_s}"}}}}}

				@dd.generate_provenance(false).should eq(results)
			end
		end

		describe "Greater than one download" do 
			before(:each) do
				@user = Factory.create(:user)
				
				@dp = Factory.create(:data_provider)
				
				@dpu = Factory.create(:data_provider_user)
				@dpu.data_provider_id = @dp.id
				@dpu.user_id = @user.id
				@dpu.save!

				@dd = Factory.create(:downloaded_datum)
				@dd.data_provider_user_id = @dpu.id
				@dd.save!
				@dd.reload

				@dd2 = Factory.create(:downloaded_datum)
				@dd2.data_provider_user_id = @dpu.id
				@dd2.save!
				@dd2.reload
			end

			it "should merge the bundles" do 
				stub_request(:post, /.*127.0.0.1.*/).to_return(:body => '{"id": "135"}')
				
				data = {"prov_json"=>{"wasAttributedTo"=>{"ex:attr#{@dd.id.to_s}"=>{"prov:agent"=>"Test2013-04-20T15:20:16", "prov:entity"=>"Facebook#{@dd.id.to_s}:bundle"}}, "prefix"=>{"ex"=>"http://localhost:3000"}, "entity"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"prov:type"=>"prov:Bundle"}, "ex:Test2013-04-20T15:20:16"=>{}, "Test"=>{}}, "specializationOf"=>{"ex:specTest2013-04-20T15:20:16"=>{"prov:specificEntity"=>"ex:Test2013-04-20T15:20:16", "prov:generalEntity"=>"Test"}}, "bundle"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"entity"=>{"ex:#{@dd.id.to_s}"=>{}, "ex:Facebook"=>{}}, "activity"=>{"ex:download#{@dd.id.to_s}"=>{"startTime"=>["2013-04-20T15:20:16", "xsd:dateTime"], "endTime"=>["2013-04-20T15:20:17", "xsd:dateTime"], "prov:type"=>"Download #{@dd.id.to_s}"}}, "specializationOf"=>{"ex:spec#{@dd.id.to_s}"=>{"prov:specificEntity"=>"ex:#{@dd.id.to_s}", "prov:generalEntity"=>"ex:Facebook"}}, "wasGeneratedBy"=>{"ex:gen#{@dd.id.to_s}"=>{"prov:entity"=>"ex:#{@dd.id.to_s}", "prov:activity"=>"ex:download#{@dd.id.to_s}"}}}}}}



				stub_request(:get, /.*127.0.0.1.*/).to_return(:body => data.to_json)



				@time_now = Time.parse("April 20 2013 15:20:16")
				Time.stub!(:now).and_return(@time_now)

				results = {"wasAttributedTo"=>{"ex:attr#{@dd2.id.to_s}"=>{"prov:agent"=>"Test2013-04-20T15:20:16", "prov:entity"=>"Facebook#{@dd2.id.to_s}:bundle"}, "ex:attr#{@dd.id.to_s}"=>{"prov:agent"=>"Test2013-04-20T15:20:16", "prov:entity"=>"Facebook#{@dd.id.to_s}:bundle"}}, "prefix"=>{"ex"=>"http://localhost:3000"}, "entity"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"prov:type"=>"prov:Bundle"}, "ex:Test2013-04-20T15:20:16"=>{}, "Test"=>{}, "Facebook#{@dd2.id.to_s}:bundle"=>{"prov:type"=>"prov:Bundle"}}, "specializationOf"=>{"ex:specTest2013-04-20T15:20:16"=>{"prov:specificEntity"=>"ex:Test2013-04-20T15:20:16", "prov:generalEntity"=>"Test"}}, "bundle"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"entity"=>{"ex:#{@dd.id.to_s}"=>{}, "ex:Facebook"=>{}}, "activity"=>{"ex:download#{@dd.id.to_s}"=>{"startTime"=>["2013-04-20T15:20:16", "xsd:dateTime"], "endTime"=>["2013-04-20T15:20:17", "xsd:dateTime"], "prov:type"=>"Download #{@dd.id.to_s}"}}, "specializationOf"=>{"ex:spec#{@dd.id.to_s}"=>{"prov:specificEntity"=>"ex:#{@dd.id.to_s}", "prov:generalEntity"=>"ex:Facebook"}}, "wasGeneratedBy"=>{"ex:gen#{@dd.id.to_s}"=>{"prov:entity"=>"ex:#{@dd.id.to_s}", "prov:activity"=>"ex:download#{@dd.id.to_s}"}}}, "Facebook#{@dd2.id.to_s}:bundle"=>{"entity"=>{"ex:#{@dd2.id.to_s}"=>{}, "ex:Facebook"=>{}}, "activity"=>{"ex:download#{@dd2.id.to_s}"=>{"startTime"=>["2013-04-20T15:20:16", "xsd:dateTime"], "endTime"=>["2013-04-20T15:20:17", "xsd:dateTime"], "prov:type"=>"Download #{@dd2.id.to_s}"}}, "specializationOf"=>{"ex:spec#{@dd2.id.to_s}"=>{"prov:specificEntity"=>"ex:#{@dd2.id.to_s}", "prov:generalEntity"=>"ex:Facebook"}}, "wasGeneratedBy"=>{"ex:gen#{@dd2.id.to_s}"=>{"prov:entity"=>"ex:#{@dd2.id.to_s}", "prov:activity"=>"ex:download#{@dd2.id.to_s}"}}}}, "wasDerivedFrom"=>{"ex:der#{@dd2.id.to_s}"=>{"prov:usedEntity"=>"Facebook#{@dd2.id.to_s}:bundle", "prov:generatedEntity"=>"Facebook#{@dd2.id.to_s}:bundle", "prov:type"=>"prov:Revision"}}}

				@dd2.generate_provenance(false).should eq(results)

			end

		end

		describe "cron job" do 
			before(:each) do
				@user = Factory.create(:user)
				
				@dp = Factory.create(:data_provider)
				
				@dpu = Factory.create(:data_provider_user)
				@dpu.data_provider_id = @dp.id
				@dpu.user_id = @user.id
				@dpu.save!

				@dd = Factory.create(:downloaded_datum)
				@dd.data_provider_user_id = @dpu.id
				@dd.save!
				@dd.reload
			end

			it "should return the new bundle with the proxy" do
				stub_request(:post, /.*127.0.0.1.*/).to_return(:body => '{"id": "135"}')

				@time_now = Time.parse("April 20 2013 15:20:16")
				Time.stub!(:now).and_return(@time_now)

				results = {"wasAttributedTo"=>{"ex:attr#{@dd.id.to_s}"=>{"prov:agent"=>"Test2013-04-20T15:20:16Proxy", "prov:entity"=>"Facebook#{@dd.id.to_s}:bundle"}}, "actedOnBehalfOf"=>{"ex:aoboTest2013-04-20T15:20:16Proxy"=>{"prov:delegate"=>"Test2013-04-20T15:20:16Proxy", "prov:responsible"=>"Test2013-04-20T15:20:16"}}, "prefix"=>{"ex"=>"http://localhost:3000"}, "entity"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"prov:type"=>"prov:Bundle"}, "ex:Test2013-04-20T15:20:16"=>{}, "Test"=>{}}, "specializationOf"=>{"ex:specTest2013-04-20T15:20:16"=>{"prov:specificEntity"=>"ex:Test2013-04-20T15:20:16", "prov:generalEntity"=>"Test"}}, "bundle"=>{"Facebook#{@dd.id.to_s}:bundle"=>{"entity"=>{"ex:#{@dd.id.to_s}"=>{}, "ex:Facebook"=>{}}, "activity"=>{"ex:download#{@dd.id.to_s}"=>{"startTime"=>["2013-04-20T15:20:16", "xsd:dateTime"], "endTime"=>["2013-04-20T15:20:17", "xsd:dateTime"], "prov:type"=>"Download #{@dd.id.to_s}"}}, "specializationOf"=>{"ex:spec#{@dd.id.to_s}"=>{"prov:specificEntity"=>"ex:#{@dd.id.to_s}", "prov:generalEntity"=>"ex:Facebook"}}, "wasGeneratedBy"=>{"ex:gen#{@dd.id.to_s}"=>{"prov:entity"=>"ex:#{@dd.id.to_s}", "prov:activity"=>"ex:download#{@dd.id.to_s}"}}}}}

				@dd.generate_provenance(true).should eq(results)
			end


		end
	end
end
