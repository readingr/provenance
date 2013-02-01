class DataProviderUser < ActiveRecord::Base
  attr_accessible :data_provider_id, :password, :user_id, :username

  belongs_to :user
  belongs_to :data_provider
  has_many :downloaded_datum



 
  
end
