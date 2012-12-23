class DataProvider < ActiveRecord::Base
  attr_accessible :name, :url

  has_many :data_provider_users
end
