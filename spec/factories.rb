Factory.define :user do |user|
  user.first_name            "Test"
  user.last_name             "User"
  user.email                 "tuser@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.prov_username         "foobar"
  user.prov_access_token          "53ba3c6f3f106162f0765424275be7d9461afd4a"
  user.current_sign_in_at "2013-04-20 16:20:16 +0100"
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
  dd.data "{\"profile_sidebar_fill_color\":\"DDEEF6\",\"id\":186553918,\"listed_count\":2,\"profile_background_image_url_https\":\"https://twimg0-a.akamaihd.net/images/themes/theme1/bg.png\",\"follow_request_sent\":false,\"screen_name\":\"readingr_uk\",\"entities\":{\"description\":{\"urls\":[]}},\"profile_background_color\":\"C0DEED\",\"contributors_enabled\":false,\"utc_offset\":0,\"url\":null,\"time_zone\":\"London\",\"verified\":false,\"name\":\"Richard Reading\",\"profile_image_url_https\":\"https://twimg0-a.akamaihd.net/profile_images/1186628718/Screen_shot_2010-12-09_at_20.10.11_normal.png\",\"location\":null,\"notifications\":false,\"profile_background_image_url\":\"http://a0.twimg.com/images/themes/theme1/bg.png\",\"protected\":false,\"is_translator\":false,\"default_profile_image\":false,\"profile_link_color\":\"0084B4\",\"lang\":\"en\",\"followers_count\":118,\"favourites_count\":30,\"profile_use_background_image\":true,\"geo_enabled\":true,\"profile_text_color\":\"333333\",\"friends_count\":164,\"id_str\":\"186553918\",\"following\":false,\"profile_sidebar_border_color\":\"C0DEED\",\"default_profile\":true,\"created_at\":\"Fri Sep 03 19:31:45 +0000 2010\",\"status\":{\"retweeted\":false,\"created_at\":\"Sat Apr 20 15:08:04 +0000 2013\",\"id_str\":\"325626928516169728\",\"geo\":null,\"in_reply_to_status_id\":null,\"coordinates\":null,\"in_reply_to_screen_name\":null,\"entities\":{\"hashtags\":[],\"user_mentions\":[],\"urls\":[]},\"place\":null,\"favorited\":false,\"truncated\":false,\"text\":\"t\",\"in_reply_to_status_id_str\":null,\"contributors\":null,\"in_reply_to_user_id\":null,\"source\":\"<a href=\\\"http://itunes.apple.com/us/app/twitter/id409789998?mt=12\\\" rel=\\\"nofollow\\\">Twitter for Mac</a>\",\"retweet_count\":0,\"id\":325626928516169728,\"in_reply_to_user_id_str\":null},\"statuses_count\":8499,\"description\":\"Computer Science Student at The University of Southampton\",\"profile_image_url\":\"http://a0.twimg.com/profile_images/1186628718/Screen_shot_2010-12-09_at_20.10.11_normal.png\",\"profile_background_tile\":false}" 
end