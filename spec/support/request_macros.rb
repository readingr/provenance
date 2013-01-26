module RequestMacros
  def login(user)
    page.driver.post user_session_path, 
      :user => {:first_name => user.first_name, :last_name => user.last_name, :email => user.email, :password => user.password}
  end
end