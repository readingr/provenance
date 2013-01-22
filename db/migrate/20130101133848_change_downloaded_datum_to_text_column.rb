class ChangeDownloadedDatumToTextColumn < ActiveRecord::Migration
	def change 
		change_column :Downloaded_Data, :data, :text 
	end
end
