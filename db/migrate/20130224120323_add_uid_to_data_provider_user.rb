class AddUidToDataProviderUser < ActiveRecord::Migration
  def change
  	add_column :data_provider_users, :uid, :string
  end
end
