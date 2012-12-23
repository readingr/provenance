class CreateDataProviderUsers < ActiveRecord::Migration
  def change
    create_table :data_provider_users do |t|
      t.integer :user_id
      t.integer :data_provider_id
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
