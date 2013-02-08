class AddCronUpdateColumnToDataProviderUsers < ActiveRecord::Migration
  def change
  	add_column :data_provider_users, :update_frequency, :string
  end
end
