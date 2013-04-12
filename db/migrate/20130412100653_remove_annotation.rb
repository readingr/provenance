class RemoveAnnotation < ActiveRecord::Migration
	def change
		remove_column :downloaded_data, :annotation
	end
end
