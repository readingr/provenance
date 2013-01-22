class DownloadedDatum < ActiveRecord::Base
  attr_accessible :annotation, :data, :name, :data_provider_user_id
  belongs_to :data_provider_user
end
