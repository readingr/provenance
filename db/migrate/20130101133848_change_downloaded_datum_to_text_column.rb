class ChangeDownloadedDatumToTextColumn < ActiveRecord::Migration
	def change 
		change_column :DownloadedDatum, :data, :text 
	end
end
