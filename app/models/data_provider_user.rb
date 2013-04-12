class DataProviderUser < ActiveRecord::Base
  attr_accessible :data_provider_id, :user_id,  :update_frequency, :uid

  validates :user_id, presence: true

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

 def micropost?
 	return self.data_provider.name == "Micropost"
 end


#The cron job calls this method which will update 
 def self.cron(time)

 	case time
	 	when "hourly"
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
 			downloaded_data = dpu.determine_update
 			downloaded_data.save
 			downloaded_data.generate_provenance(true)
 		end
 	end
 end

 def determine_update
 	if self.facebook?
 		return self.update_facebook
 	elsif self.twitter?
 		return self.update_twitter
 	elsif self.micropost?
 		return self.update_micropost
 	else
 		raise "error, not a data provider user option"
 	end
 end



 def update_twitter

 	Twitter.configure do |config|
 	  config.consumer_key = "fYuL73SIEuhw6kgNvs2hA"
 	  config.consumer_secret = "49ujIlgckdjJGbuKV8IafH9rKuvO6PlSCuxEVspd4"
 	  config.oauth_token = self.access_token
 	  config.oauth_token_secret = self.oauth_token_secret 
 	end
	
	#this parses the results 	 
 	json_results = Twitter.user.to_json
 	return DownloadedDatum.new(name: "Twitter", data: json_results, data_provider_user_id: self.id)
 end

 def update_facebook

 	options = { :access_token => self.access_token, :format => 'json' }
 	query = Fql.execute({
 		"query1" => 'SELECT status_id, message, time, uid FROM status WHERE uid ='+self.uid,
 		"query2" => 'SELECT first_name, last_name, profile_url, sex, pic_small, about_me, friend_count, inspirational_people, username FROM user WHERE uid ='+self.uid
 	}, options)
 	results = (query[0].values[1])[0].merge(query[1].values[1][0])


 	json_results = results.to_json
 	return DownloadedDatum.new(name: "Facebook", data: json_results, data_provider_user_id: self.id)

 end

 def update_micropost
 	require 'net/http'
 	uri = URI("http://localhost:3001/users/#{self.uid.to_s}/get_last_micropost")

 	response = Net::HTTP.get(uri)

 	return DownloadedDatum.new(name:"Micropost", data: response, data_provider_user_id: self.id)

 end

  
end
