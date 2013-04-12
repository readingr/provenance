class RemoveUsernameAndPassword < ActiveRecord::Migration
	def change
		remove_column :data_provider_users, :username
		remove_column :data_provider_users, :password
	end
end
