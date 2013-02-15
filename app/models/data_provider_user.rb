class DataProviderUser < ActiveRecord::Base
  attr_accessible :data_provider_id, :password, :user_id, :username, :update_frequency

  belongs_to :user
  belongs_to :data_provider
  has_many :downloaded_datum, :dependent => :destroy


#checks to see whether it's facebook
 def facebook?
  return self.data_provider.name == "Facebook"
 end

 def twitter?
 	return self.data_provider.name == "Twitter"
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
 	elsif self.twitter?
 		return self.update_twitter
 	else
 		puts "not fb/twitter"
 		puts "**************"
 		debugger
 		# return self.update_facebook
 	end
 end



 def update_twitter
 	require 'ProvRequests'
 	# puts "******************"


 	Twitter.configure do |config|
 	  config.consumer_key = "fYuL73SIEuhw6kgNvs2hA"
 	  config.consumer_secret = "49ujIlgckdjJGbuKV8IafH9rKuvO6PlSCuxEVspd4"
 	  config.oauth_token = self.access_token
 	  config.oauth_token_secret = self.oauth_token_secret 
 	end
 	 
 	# Twitter.update("Hello World!")
 	# debugger
 	json_results = Twitter.user.to_json
 	return DownloadedDatum.new(name: "Twitter", data: json_results, data_provider_user_id: self.id)
 end

 def update_facebook
 	require 'ProvRequests'

 	options = { :access_token => self.access_token, :format => 'json' }
 	query = Fql.execute({
 		"query1" => 'SELECT status_id, message, time, uid FROM status WHERE uid = 1144492288',
 		"query2" => 'SELECT first_name, last_name, profile_url, sex, pic_small, about_me, friend_count, inspirational_people, username FROM user WHERE uid = 1144492288'
 	}, options)
 	results = (query[0].values[1])[0].merge(query[1].values[1][0])
 	debugger

 	json_results = results.to_json
 	# json_results = ActiveSupport::JSON.decode(response.body)[0].to_json
 	# debugger

 	return DownloadedDatum.new(name: "Facebook", data: json_results, data_provider_user_id: self.id)

 end

  
end
