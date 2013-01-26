Factory.define :user do |user|
  user.first_name            "Test"
  user.last_name             "User"
  user.email                 "tuser@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end