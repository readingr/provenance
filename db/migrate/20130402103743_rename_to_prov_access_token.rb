class RenameToProvAccessToken < ActiveRecord::Migration
	def change
		rename_column :Users, :access_token, :prov_access_token
	end
end
