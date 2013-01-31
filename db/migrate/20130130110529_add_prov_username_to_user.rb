class AddProvUsernameToUser < ActiveRecord::Migration
  def change
  	add_column :users, :prov_username, :string
  end
end
