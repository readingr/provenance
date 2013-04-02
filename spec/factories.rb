Factory.define :user do |user|
  user.first_name            "Test"
  user.last_name             "User"
  user.email                 "tuser@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.prov_username         "foobar"
  user.prov_access_token          "53ba3c6f3f106162f0765424275be7d9461afd4a"
end
Factory.define :data_provider do |data_provider|
  data_provider.name            "Facebook"
  data_provider.url             "http://www.facebook.com"
end
Factory.define :data_provider_user do |dpu|
  dpu.user_id 1
  dpu.access_token nil
  dpu.update_frequency nil
  dpu.oauth_token_secret nil
  dpu.uid             nil

end
Factory.define :downloaded_datum do |dd|
  dd.name "foo"
  dd.data "bar"
end