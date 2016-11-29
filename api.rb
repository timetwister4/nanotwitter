require 'sinatra'
require 'sinatra/activerecord'
require_relative 'tweetprocessor.rb'
require 'byebug'
require_relative 'models/user'
require_relative 'models/tweet'


post'/api/v1/tweets/:tweet_id/' do
  Tweet.find(params[:tweet_id]).to_json
end

post '/api/v1/users/:user_name/' do
  User.find_by_user_name(params[:user_name]).to_json
end

post '/api/v1/tweets/:tweet_id/replies' do
  #I think this should be a database call, rather than a cache call. The cache should be for user timelines
	RedisClass.access_replies(params[:tweet_id]).to_json
end

post '/api/v1/users/:user_name/tweets' do
  User.where(user_name: params[:user_name])[0].tweets.to_json
end

post '/api/v1/tag/:tag_name' do
	RedisClass.access_tag(params[:tag_name]).to_json
end

post '/api/v1/users/:user_name/home_feed' do
	u = User.where(:user_name => params[:user_name])
	RedisClass.access_hfeed(u.id).to_json
end

post '/api/v1/follows/:user_name/followings' do
	u = User.where(:user_name => params[:user_name])
	RedisClass.access_followings(u.id).to_json
end

post '/api/v1/tweets/:tweet_id/likes' do
	RedisClass.access_likes(params[:tweet_id]).to_json
end
