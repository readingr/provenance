class CreateDownloadedData < ActiveRecord::Migration
  def change
    create_table :downloaded_data do |t|
      t.string :name
      t.string :data
      t.string :annotation

      t.timestamps
    end
  end
end
