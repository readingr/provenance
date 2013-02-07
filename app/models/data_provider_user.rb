class DataProviderUser < ActiveRecord::Base
  attr_accessible :data_provider_id, :password, :user_id, :username

  belongs_to :user
  belongs_to :data_provider
  has_many :downloaded_datum, :dependent => :destroy


#checks to see whether it's facebook
 def facebook?
  return self.data_provider.name == "Facebook"
 end

#class method
 def self.test
 	puts "*****************"
 	puts "TESTING"
 	puts ""
 end
  
end
