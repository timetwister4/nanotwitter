require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'config/config_sinatra'
require_relative 'config/initializers/redis'
require_relative 'usr/bin/dev/send.rb'
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
require 'sinatra/content_for'


TweetFactory = TweetProcessor.new

# loader.io access routes
get '/loaderio-accded2323af55270a8895980c841782.txt' do
  send_file 'loaderio-accded2323af55270a8895980c841782.txt'
end

get '/loaderio-97e86023c438b5621c512742d95a8419.txt' do
  "loaderio-97e86023c438b5621c512742d95a8419.txt"
end

# root
get '/' do
  if authenticate!
    byebug
    u = User.where(id: session[:user_id])
    @user = u[0]
    @tweets = RedisClass.access_hfeed(session[:user_id])
    erb :my_home # personalized homepage
  else
    @tweets = RedisClass.access_ffeed
    erb:home

  end
end

# equivalent to logged out front page
get '/front' do
  @tweets = RedisClass.access_ffeed
  erb :home
end

# Login URLs #
get '/login' do
  erb :login
end

post '/login/submit' do
  #login handles session[:user_id] and expiration now
  successful_log_in = login(params)
	if successful_log_in
    session[:error] = ""
    redirect '/'
  else
    session[:error] = "Incorrect login information"#This still needs to just create an error dialog instead of redirecting automatically to registration
    redirect '/login'
  end
end

# inline login
get '/?user=:user_name&password=:password' do
  login(params)
  redirect '/'
end

get '/?user=:anotheruser&password=:password&randomtweet=50' do
  login(params)

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
      session[:user_id] = u.id
      redirect '/'
    else
      redirect '/registration'
    end
end

# User Profile URLs and Functions #

# Logged in user's profile
get '/profile' do
  if authenticate!
    @user = User.find(session[:user_id])
    @tweets = RedisClass.access_pfeed(session[:user_id])
    erb :profile
  else
    erb :error
  end
end

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


post '/user/follow' do

  follower = User.find(session[:user_id])# the person following
  followed = User.find_by_user_name(params[:user_name]) # the person being followed
  follower.increment_followings
  followed.increment_followers
  RedisClass.cache_follow(session[:user_id], followed.id)
  f = Follow.create(follower: follower, followed: followed)
  f.save # not necessary with the create command
  redirect '/user' + followed.user_name

end


post '/user/unfollow' do

  follower = User.find(session[:user_id])# the person following
  followed = User.find_by_user_name(params[:user_name]) # the person being followed

  Follow.where(follower: User.find(session[:user_id]),followed_id: User.find_by_user_name(params[:user_name])).destroy_all
  RedisClass.cache_unfollow(session[:user_id], followed.id)

  follower.decrement_followings
  followed.decrement_followers

  redirect '/user' + followed.user_name

end

# note the asterisk means that no matter what comes before this it will work
post '*/tweet/new/submit' do
  text = params[:tweet_text]
  TweetFactory.make_tweet(text, session[:user_id], nil)# Tweet.create(text: text, author: author, author_name: author.user_name) and calls the feed processor
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
TweetFactory.make_tweet(text, session[:user_id], params[:reply_id])
redirect '/'
end



get '/test' do

  keys = RedisClass.number_of_keys

end

# post '/tweet/:tweet_id/like' do
#   #need to keep track of which users like which tweets

# end

# post '/tweet/:tweet_id/unlike' do

# end
