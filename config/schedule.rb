# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment, "development"
set :output, 'log/cron.log'


# every :hour do
# 	runner "DataProviderUser.cron('hourly')"
# end

every :day do
	runner "DataProviderUser.cron('daily')"
end

every '0 0 * * 0' do
	runner "DataProviderUser.cron('weekly')"
end

every 14.days do
	runner "DataProviderUser.cron('fortnightly')"
end

every :month do
	runner "DataProviderUser.cron('monthly')"
end

# run minutely for testing
every '*/1 * * * *' do
	runner "DataProviderUser.cron('hourly')"
end