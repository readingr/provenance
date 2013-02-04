class CreateProvServices < ActiveRecord::Migration
  def change
    create_table :prov_services do |t|
      t.string :username
      t.text :access_token

      t.timestamps
    end
  end
end
