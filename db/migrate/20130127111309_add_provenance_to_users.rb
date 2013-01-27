class AddProvenanceToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :consumer_key, :text
  	add_column :users, :consumer_secret, :text
  	add_column :users, :token, :text
	add_column :users, :token_secret, :text
  	
  end
end
