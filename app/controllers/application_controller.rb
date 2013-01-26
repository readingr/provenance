class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :authenticate_user!
  # load_and_authorize_resource :downloaded_datum, :through => :data_provider_user


  def after_sign_in_path_for(resource)
	prov_login_users_path
  end


end
