class AddUserIdToProvServices < ActiveRecord::Migration
  def change
  	add_column :prov_services, :user_id, :integer
  end
end
