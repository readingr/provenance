class RemoveUrlColumnFromDataProviders < ActiveRecord::Migration
	def change
		remove_column :data_providers, :url
	end
end
