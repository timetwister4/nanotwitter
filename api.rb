require_relative "app.rb"

get '/api/v1/tweets/:tweet_id' do
	if Tweet.where(id: params[:tweet_id].to_i).exists?
	   @data = Tweet.find(params[:tweet_id].to_i).to_json
	   erb :test
	else 
	   @data = "	no data"
	   erb :test
	end

	
end

get '/api/v1/tweets/front_feed' do
   RedisClass.access_ffeed.to_json
end

get '/api/v1/users/:user_name' do
  User.find(params[:user_id]).to_json
end

get '/api/v1/tweets/:tweet_id/replies' do
   RedisClass.access_replies(params[:tweet_id]).to_json
end

get '/api/v1/users/:user_name/tweets' do
  	User.where(user_name: params[:user_name])[0].tweets.to_json
end

get '/api/v1/tag/:tag_name' do
	RedisClass.access_tag(params[:tag_name]).to_json
end


get '/api/v1/users/:user_name/home_feed' do
	u = User.where(:user_name => params[:user_name])
	RedisClass.access_hfeed(u.id).to_json
end

get '/api/v1/follows/:user_name/followings' do
	u = User.where(:user_name => params[:user_name])
	Follow.where(follower: u).to_json
end

get '/api/v1/follows/:user_name/followers' do
	u = User.where(:user_name => params[:user_name])
	Follow.where(followed: u).to_json
end

get '/api/v1/tweets/:tweet_id/likes' do
	RedisClass.access_likes(params[:tweet_id]).to_json
end

get '/api/v1/tweets/:key_word/search' do
	TweetFactory = TweetProcessor.new
	TweetFactory.search_tweets(params[:key_word]).to_json
end


