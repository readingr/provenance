class AddOauthTokenSecretToDataProviderUser < ActiveRecord::Migration
  def change
  	add_column :data_provider_users, :oauth_token_secret, :string
  end
end
