class CreateDataProviders < ActiveRecord::Migration
  def change
    create_table :data_providers do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
