class AddAccessTokenToUser < ActiveRecord::Migration
  def change
  	add_column :users, :access_token, :text
  	remove_column :users, :consumer_key
  	remove_column :users, :consumer_secret
  	remove_column :users, :token
	remove_column :users, :token_secret
  end
end
