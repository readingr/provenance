class ProvService < ActiveRecord::Base
  attr_accessible :access_token, :username

  belongs_to :user
end
