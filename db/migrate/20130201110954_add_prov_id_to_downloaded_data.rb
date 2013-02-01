class AddProvIdToDownloadedData < ActiveRecord::Migration
  def change
  	add_column :downloaded_data, :prov_id, :integer
  end
end
