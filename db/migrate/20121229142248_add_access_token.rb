class AddAccessToken < ActiveRecord::Migration
	def change
 		add_column :dataproviderusers, :access_token, :string
 	end
end
