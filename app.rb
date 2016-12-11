require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/content_for'
require 'json'
require_relative 'config/environments'
require_relative 'config/config_sinatra'
require_relative 'config/initializers/redis'
require_relative 'helpers/authentication.rb'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require_relative 'models/follow.rb'
require_relative 'tweetprocessor.rb'
require 'redis'
require_relative 'redis_operations'
require_relative 'api.rb'
require 'faker'

TweetFactory = TweetProcessor.new

# loader.io access routes
get '/loaderio-accded2323af55270a8895980c841782.txt' do
  send_file 'loaderio-accded2323af55270a8895980c841782.txt'
end

get '/loaderio-97e86023c438b5621c512742d95a8419.txt' do
  send_file 'loaderio-97e86023c438b5621c512742d95a8419.txt'
end

get '/' do
  if authenticate!
       home_page(User.where(id: session[:user_id]))
  elsif test_2_or_3?(params)
       home_page(User.where(user_name: params[:user]))
  else
     @tweets = RedisClass.access_ffeed
     @ffeed = true
     erb :home
  end
end

def home_page(user)
     @home = true #in order for the user_info erb to differentiate between my_home and profile
     @user = user[0]
     @tweets = RedisClass.access_hfeed(session[:user_id])
     erb :my_home
end

def test_2_or_3?(params)
    if params[:user] && params[:password] && login(params)
        if params[:randomtweet] && (rand < (params[:randomtweet].to_f / 100))
           TweetFactory.make_tweet(Faker::Hacker.say_something_smart, session[:user_id], nil)
        end
       return true
    end
end

get '/front' do
  @tweets = RedisClass.access_ffeed
  erb :home
end

get '/login' do
  erb :login
end

post '/login/submit' do
    if login(params)
        session[:error] = ""
        redirect '/'
    else
       session[:error] = "Incorrect login information"
       redirect '/login'
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
        session[:user_id] = u.id
        session[:user_name] = u.user_name
        redirect '/'
    else
        redirect '/registration'
    end
end

get '/user/:user_name' do
    if User.where(user_name: params[:user_name]).exists? && logged_in?
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
    followed = User.find_by_user_name(params[:user_name])
    Follow.create(follower_id: session[:user_id], followed_id: followed.id)
    user = User.find(session[:user_id])
    user.increment_followings
    followed.increment_followers
    redirect "user/" + params[:user_name]
end

post '/user/unfollow' do
    followed = User.find_by_user_name(params[:user_name]) # the person being followed
    Follow.where(follower_id: session[:user_id], followed_id: followed.id).destroy_all
    user = User.find(session[:user_id])
    user.decrement_followings
    followed.decrement_followers
    redirect redirect "user/" + params[:user_name]
end

# note the asterisk means that no matter what comes before this it will work
post '/tweet/new/submit' do
    text = params[:tweet_text]
    TweetFactory.make_tweet(text, session[:user_id], nil)# Tweet.create(text: text, author: author, author_name: author.user_name) and calls the feed processor
    redirect "user/" + session[:user_name]
end

# Other #
get '/search/?' do
    if logged_in?
      @keyword = params[:keyword] 
      @tweets = TweetFactory.search_tweets(@keyword)
      erb :search
    end
end

post '/tweet/like' do
    tweet = Tweet.find(params[:tweet_id])
    if !RedisClass.liked_before?(session[:user_id],tweet.id)
      tweet.increment_likes
      RedisClass.cache_likes(session[:user_id],tweet.id)
      tweet.likes.to_json
    else
      "a#{tweet.likes}".to_json
    end
end


get '/tag/:name' do
   if logged_in?
      @tag = params[:name]
      @tweets = RedisClass.access_tag(@tag)
      erb :tag
   end
end

get '/tweet/replies' do  #This block accesses all the replies of a certain tweet stored in redis
    replies = RedisClass.access_replies(params[:tweet_id])
    replies.to_json
end

post '/tweet/reply/:reply_id' do
    text = params[:tweet_text]
    TweetFactory.make_tweet(text, session[:user_id], params[:reply_id])
    redirect '/'
end

get '/gh-page' do
  erb :gh_page
end

def delete_all
  RedisClass.delete_keys
  Tweet.delete_all
  Follow.delete_all
  users = User.all
  users.each do |u|
    u.follower_count = 0
    u.following_count = 0
    u.tweet_count = 0
    u.save
  end
end



