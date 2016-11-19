require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'config/config_sinatra'
require_relative 'config/initializers/redis'
require 'byebug'
require_relative 'helpers/authentication.rb'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require_relative 'models/follow.rb'
require_relative 'tweetprocessor.rb'
require_relative 'redis_operations.rb'
require 'json'
require 'redis'
require 'redis-namespace'
require_relative 'api.rb'


TweetFactory = TweetProcessor.new
get '/loaderio-accded2323af55270a8895980c841782.txt' do
  send_file 'loaderio-accded2323af55270a8895980c841782.txt'
end

#root
get '/' do
  if authenticate!
    u = User.where(id: session[:user_id])
    @user = u[0]
    @tweets = RedisClass.access_hfeed(session[:user_id])
    erb :my_home #personalized homepage
  else
    @tweets = Tweet.last(7)
    erb :home #a generic homepage
  end
end

#in case a logged in user wants to see the general front page of nT
get '/front' do
  @tweets = Tweet.last(7)
  erb :home
end


get '/profile' do
  if authenticate!
    @user = User.find(session[:user_id])
    #@user = u[0]
    @tweets = RedisClass.access_pfeed(session[:user_id])
    erb :profile
  else
    erb :error
  end
end



# Login URLs #
get '/login' do
  erb :login
end

post '/login/submit' do
  successful_log_in = login(params)
	if successful_log_in
	   #u = User.where(email: params[:email], password: params[:password])
	  # @user = u[0] #in order to become the array of fields
     session[:user_id] = @user.id
     session[:expires_at] = Time.current + 10.minutes
     redirect '/'
  else
     redirect '/registration'
  end
end


get'/logout' do
    log_out_now
    redirect '/'
end

# Account Registration URLs #

get '/registration/?' do
  erb :registration
end

post '/registration/submit' do
   u = User.create(name: params[:name], email: params[:email], user_name: params[:user_name], password: params[:password])
    if u.save
      RedisClass.cache_general(u)
      session[:user_id] = u.id
      redirect '/'
    else
      redirect '/registration'
    end
end

# User Profile URLs and Functions #

get '/user/:user_name' do
    if User.where(user_name: params[:user_name]).exists?
      u = User.where(user_name: params[:user_name])
      @user = u[0]
      @follow_status = Follow.where(follower_id: session[:user_id], followed_id: @user.id).exists?
      @tweets = RedisClass.access_pfeed(@user.id)
      erb :profile
    else
      erb :error
    end
end


post '/user/:user_name/follow' do
  follower = User.find(session[:user_id])#the person following
  followed = User.find_by_user_name(params[:user_name]) #the person being followed

    #follower.following_count += 1
    follower.increment_followings
    #followed.follower_count += 1
    followed.increment_followers
    RedisClass.cache_follow(session[:user_id], followed.id)
    f = Follow.create(follower: follower, followed: followed)

    f.save
  redirect "/user/#{params[:user_name]}"
end


post '/user/:user_name/unfollow' do
  follower = User.find(session[:user_id])#the person following
  followed = User.find_by_user_name(params[:user_name]) #the person being followed
  Follow.where(follower: User.find(session[:user_id]),followed_id: User.find_by_user_name(params[:user_name])).destroy_all
  RedisClass.cache_unfollow(session[:user_id], followed.id)
  follower.decrement_followings
  followed.decrement_followers
  redirect "/user/#{params[:user_name]}"
end

# note the asterisk means that no matter what comes before this it will work
post '*/tweet/new/submit' do
  text = params[:tweet_text]
  t = TweetFactory.make_tweet(text, session[:user_id], nil)#Tweet.create(text: text, author: author, author_name: author.user_name) and calls the feed processor
  redirect '#';
end


# Other #
get '/search/?' do
  keyword = params[:keyword]
  @tweets = TweetFactory.search_tweets(keyword)
  erb :search
end

post '/tweet/like' do
  tweet = Tweet.find(params[:tweet_id])
  RedisClass.cache_likes(tweet.id, session[:user_id], tweet).to_json
end


get '/tag/:name' do
  @tag_name = params[:name]
  @tweets = RedisClass.access_tag(@tag_name)
  erb :tag

end

get '/tweet/replies' do  #This get block accesses all the replies of a certain tweet stored in redis
  {:id => params[:tweet_id], :replies => RedisClass.access_pfeed(1)}.to_json #this is to test how would we unparse the text
end

post '/tweet/reply/:reply_id' do
text = params[:tweet_text]
t = TweetFactory.make_tweet(text, session[:user_id], params[:reply_id])
redirect '/'
end


# post '/tweet/:tweet_id/like' do
#   #need to keep track of which users like which tweets

# end

# post '/tweet/:tweet_id/unlike' do

# end


post '/ajax/test' do

  "<p> Test paragraph</p>"
end
