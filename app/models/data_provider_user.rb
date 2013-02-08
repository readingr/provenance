class DataProviderUser < ActiveRecord::Base
  attr_accessible :data_provider_id, :password, :user_id, :username

  belongs_to :user
  belongs_to :data_provider
  has_many :downloaded_datum, :dependent => :destroy


#checks to see whether it's facebook
 def facebook?
  return self.data_provider.name == "Facebook"
 end


#The cron job calls this method which will update 
 def self.cron(time)

 	case time
	 	when "hourly"
	 		puts "hourly"
	 		data_provider_users = DataProviderUser.where(update_frequency: "hourly")
	 	when "daily"
	 		data_provider_users = DataProviderUser.where(update_frequency: "daily")

	 	when "fortnightly"
	 		data_provider_users = DataProviderUser.where(update_frequency: "fortnightly")

	 	when "weekly"
	 		data_provider_users = DataProviderUser.where(update_frequency: "weekly")

	 	when "monthly"
	 		data_provider_users = DataProviderUser.where(update_frequency: "monthly")
 	end

 	if !data_provider_users.empty?

 		data_provider_users.each do |dpu|
 			# puts dpu.user_id
 			# puts dpu.data_provider.name

 			#need to make a non-generic path
 			downloaded_data = dpu.determine_update
 			downloaded_data.save
 			downloaded_data.generate_provenance
 		end
 	end
 end

 def determine_update
 	if self.facebook?
 		return self.update_facebook
 	else
 		puts "not facebook"
 		return self.update_facebook
 	end
 end


 def update_facebook
 	require 'ProvRequests'

 	options = { :access_token => self.access_token, :format => 'json' }
 	query = Fql.execute({"query1" => 'SELECT first_name, last_name, profile_url, sex, pic_small, about_me, friend_count, inspirational_people, username FROM user WHERE uid = 1144492288'}, options)
 	# query = Fql.execute({"query1" => 'SELECT message FROM status WHERE uid = 1144492288'}, options)
 	results = (query[0].values[1])[0]


 	json_results = results.to_json

 	return DownloadedDatum.new(name: "Facebook", data: json_results, data_provider_user_id: self.id)

 end

  
end
