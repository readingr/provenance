require 'spec_helper'

describe DataProviderUser do


	it "should have a valid factory" do
		Factory.create(:data_provider_user).should be_valid
	end

	it "is invalid without a user_id" do
	  Factory.build(:data_provider_user, user_id: nil).should_not be_valid
	end

	describe "facebook?" do
		before(:each) do
			@dp = Factory.create(:data_provider)
			@dpu = Factory.create(:data_provider_user)
			@dpu.data_provider_id = @dp.id
		end

		it "should return true" do
			@dp.name = "Facebook"
			@dp.save
			@dpu.facebook?.should eq(true)
		end
		it "should return false" do
			@dp.name = "Twitter"
			@dp.save
			@dpu.facebook?.should eq(false)
		end
	end

	describe "twitter?" do
		before(:each) do
			@dp = Factory.create(:data_provider)
			@dpu = Factory.create(:data_provider_user)
			@dpu.data_provider_id = @dp.id
		end

		it "should return true" do
			@dp.name = "Twitter"
			@dp.save
			@dpu.twitter?.should eq(true)
		end
		it "should return false" do
			@dp.name = "Facebook"
			@dp.save
			@dpu.twitter?.should eq(false)
		end
	end

	describe "determine_update" do
		before(:each) do
			@dp = Factory.create(:data_provider)
			@dpu = Factory.create(:data_provider_user)
			@dpu.data_provider_id = @dp.id
		end

		it "should call update facebook method" do
			DataProviderUser.any_instance.stub(:update_facebook).and_return("Facebook")
			@dp.name = "Facebook"
			@dp.save
			@dpu.determine_update.should eq("Facebook") 
		end

		it "should call update twitter method" do
			DataProviderUser.any_instance.stub(:update_twitter).and_return("Twitter")
			@dp.name = "Twitter"
			@dp.save
			@dpu.determine_update.should eq("Twitter") 
		end

		it "should raise an error" do
			@dp.name = "ERROR NAME"
			@dp.save
			expect {@dpu.determine_update}.to raise_error
		end
	end

	describe "update_facebook" do
		before(:each) do
			@dp = Factory.create(:data_provider)
			@dpu = Factory.create(:data_provider_user)
			@dpu.data_provider_id = @dp.id
		end

		it "should return the right data" do
			Twitter.stub(:user).and_return({:id=>186553918})
			dd = @dpu.update_twitter
			dd.data.should eq("{\"id\":186553918}")
		end

	end

	describe "update_facebook" do
		before(:each) do
			@dp = Factory.create(:data_provider)
			@dpu = Factory.create(:data_provider_user)
			@dpu.data_provider_id = @dp.id
		end

		it "should return the right data" do
			Fql.stub(:execute).and_return([{"name"=>"query2", "fql_result_set"=>[{"first_name"=>"Richard", "last_name"=>"Reading", "profile_url"=>"http://www.facebook.com/richard.reading", "sex"=>"male", "pic_small"=>"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/187457_1144492288_2052468256_t.jpg", "about_me"=>"Skype : richardreading", "friend_count"=>384, "inspirational_people"=>[], "username"=>"richard.reading"}]}, {"name"=>"query2", "fql_result_set"=>[{"first_name"=>"Richard", "last_name"=>"Reading", "profile_url"=>"http://www.facebook.com/richard.reading", "sex"=>"male", "pic_small"=>"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/187457_1144492288_2052468256_t.jpg", "about_me"=>"Skype : richardreading", "friend_count"=>384, "inspirational_people"=>[], "username"=>"richard.reading"}]}])
			@dpu.uid = "123"
			dd = @dpu.update_facebook

			dd.data.should eq("{\"first_name\":\"Richard\",\"last_name\":\"Reading\",\"profile_url\":\"http://www.facebook.com/richard.reading\",\"sex\":\"male\",\"pic_small\":\"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/187457_1144492288_2052468256_t.jpg\",\"about_me\":\"Skype : richardreading\",\"friend_count\":384,\"inspirational_people\":[],\"username\":\"richard.reading\"}")
		end
	end

	describe "cron" do
		before(:each) do
			@dp = Factory.create(:data_provider)
			@dpu = Factory.create(:data_provider_user)
			@dpu.data_provider_id = @dp.id
		end

		#not sure how to test this >.>

		# it "should call hourly" do
		# 	@dpu.update_frequency = "hourly"
		# 	DataProviderUser.cron

		# end
	end
end
