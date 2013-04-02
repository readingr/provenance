class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  validates :first_name, :last_name, :prov_username, :prov_access_token, :presence => true

  has_many :data_provider_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :prov_username, :prov_access_token



  def overall_prov
  	puts "*************"
    require 'ProvRequests'
    require 'json'
    require 'active_support/core_ext/hash/deep_merge'

    prov = {}
  	@dpu = self.data_provider_users

  	@dpu.each do |dpu|
  		if !dpu.downloaded_datum.blank?
  			request = ProvRequests.get_request(self.prov_username, self.prov_access_token, dpu.downloaded_datum.last.prov_id)
  			results = ActiveSupport::JSON.decode(request)["prov_json"]
  			prov = prov.deep_merge(results)
  		end
  	end

  	if !prov.blank?
  		response = ProvRequests.post_request(self.prov_username, self.prov_access_token, prov, "Complete Prov")
  		prov_id = ActiveSupport::JSON.decode(response)["id"]
  		# debugger	
  		return "#{ENV['PROV_SERVER']}/store/bundles/#{prov_id}"
  	else	
  		return nil
  	end

  end
end
