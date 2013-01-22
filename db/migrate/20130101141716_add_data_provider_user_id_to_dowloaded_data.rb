class AddDataProviderUserIdToDowloadedData < ActiveRecord::Migration
	def change
 		add_column :downloaded_data, :data_provider_user_id, :integer
 	end
end
