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
	  "success".to_json  
end

get '/api/v1/tweets/:tweet_id/replies' do
    RedisClass.access_replies(params[:tweet_id]).to_json
end

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
	find_follows(params[:user_name], false)
end

get '/api/v1/follows/:user_name/followers' do
	find_follows(params[:user_name],true)
end


	
def find_follows(user_name, followers)
    if User.where(user_name: params[:user_name]).exists?
	   	u = User.where(:user_name => params[:user_name])
	    if followers
	    	get_names(Follow.where(followed: u),true, [])
	    else
	        get_names(Follow.where(follower: u), false, [])		        	
	    end
	end
end

def get_names(list,followers, names)
    if followers
    	list.each do |item| 
    		names << User.find(item.follower_id).user_name
    	end
   	else
   		list.each do |item|
   			names << User.find(item.followed_id).user_name
   		end
   	end
   	names.to_json
end


get '/api/v1/tweets/:tweet_id/likes' do
    RedisClass.access_likes(params[:tweet_id]).to_json
	
end

get '/api/v1/tweets/:key_word/search' do
	TweetFactory = TweetProcessor.new
  	TweetFactory.search_tweets(params[:key_word]).to_json

end



