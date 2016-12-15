require_relative "app.rb"

default = "no_data".to_json

get '/api/v1/tweets/:tweet_id' do
	if Tweet.where(id: params[:tweet_id].to_i).exists?
	   Tweet.where(id: params[:tweet_id].to_i).to_json
	end
end

get '/api/v1/front-feed' do
   RedisClass.access_ffeed.to_json
end

get '/api/v1/users/:user_name' do
  if User.where(user_name: params[:user_name]).exists?
  	 User.where(user_name: params[:user_name])[0].to_json
  end

end

post '/api/v1/login' do
 	  login(params).to_json
end

post '/api/v1/users/:user_name/new-tweet' do
	  TweetFactory = TweetProcessor.new
	  id = User.where(user_name: params[:user_name])[0].id
	  TweetFactory.make_tweet(params[:text],id,nil)
end

get '/api/v1/tweets/:tweet_id/replies' do
    RedisClass.access_replies(params[:tweet_id]).to_json
end

# get '/api/v1/users/:user_name/tweets' do
#    if User.where(user_name: params[:user_name]).exists?
#   	  User.where(user_name: params[:user_name])[0].tweets.to_json
#   else
#   	default
#   end
  
# end

get '/api/v1/tag/:tag_name' do
	 RedisClass.access_tag(params[:tag_name]).to_json

end


get '/api/v1/users/:user_name/profile-feed' do
	  if User.where(user_name: params[:user_name]).exists?
	  	  id = User.where(:user_name => params[:user_name])[0].id
	  	  RedisClass.access_pfeed(id).to_json
	  end
end

get '/api/v1/users/:user_name/home-feed' do
	  if User.where(user_name: params[:user_name]).exists?
	  	  id = User.where(:user_name => params[:user_name])[0].id
	  	  RedisClass.access_hfeed(id).to_json
	  end
end


get '/api/v1/follows/:user_name/followings' do
	if User.where(user_name: params[:user_name]).exists?
	   u = User.where(:user_name => params[:user_name])
	   Follow.where(follower: u).to_json
	end
	
end

get '/api/v1/follows/:user_name/followers' do
	if User.where(user_name: params[:user_name]).exists?
	   u = User.where(:user_name => params[:user_name])
	   Follow.where(followed: u).to_json
  	end
end

get '/api/v1/tweets/:tweet_id/likes' do
    RedisClass.access_likes(params[:tweet_id]).to_json
	
end

get '/api/v1/tweets/:key_word/search' do
	TweetFactory = TweetProcessor.new
  	TweetFactory.search_tweets(params[:key_word]).to_json

end



