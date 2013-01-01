class AddAccessToken < ActiveRecord::Migration
	def change
 		add_column :data_provider_users, :access_token, :string
 	end
end
