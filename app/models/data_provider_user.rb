class DataProviderUser < ActiveRecord::Base
  attr_accessible :data_provider_id, :password, :user_id, :username

  belongs_to :user
  belongs_to :data_provider


  # def update_facebook

  #   @data_provider_user = DataProviderUser.find(params[:id])

  #   #validation needed here if there is no facebook login.    
  #   options = { :access_token => "AAAEY0v0jyfwBACkYYJeMMymgWBDZB1jl9HhZCqavxnBBuAxnztU8VG62V3esGog3VOZAbTmHVPOh8cAScZBtOtAZC86xk6lZCRAWPHHoOun69VOPHZB4CEi" }
  #   query = Fql.execute({"query1" => 'SELECT first_name, last_name, profile_url, sex, pic_small, about_me, friend_count, inspirational_people, username FROM user WHERE uid = 1144492288'}, options)
  #   results = (query[0].values[1])[0]

  #   # respond_to do |format|
  #   #   format.html { redirect_to data_provider_users_url }
  #   #   format.json { head :no_content }
  #   # end
  # end
  
end
