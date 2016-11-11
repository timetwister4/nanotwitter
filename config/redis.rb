gem 'redis'
gem 'redis-namespace'
$redis = Redis::Namespace.new("my_app", :redis => Redis.new)