require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'config/config_sinatra'
require 'byebug'
require_relative 'helpers/authentication.rb'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require_relative 'models/follow.rb'
require_relative 'tweetprocessor.rb'

require_relative 'models/feed.rb'



TweetFactory = TweetProcessor.new

get '/loaderio-accded2323af55270a8895980c841782.txt' do
  send_file 'loaderio-accded2323af55270a8895980c841782.txt'
end

#root
get '/' do
  if authenticate!
    u = User.where(id: session[:user_id])
    @user = u[0]
    #@tweets = Tweet.where(author_id: session[:user_id])
    @feed = Feed.get_myhome_feed(session[:user_id])
    @tweets = Feed.prepare_tweet_array(@feed) #puts all the tweet content together by pulling the tweets' ids from @feed. It makes an array of all these tweets
    erb :my_home #personalized homepage
  else
    @feed = Feed.get_home_feed
    @tweets = Feed.prepare_tweet_array(@feed)
    erb :home #a generic homepage
  end
end


get '/profile' do
  if authenticate!
    u = User.where(id: session[:user_id])
    @user = u[0]
    @feed = Feed.get_profile_feed(session[:user_id])
    @tweets = Feed.prepare_tweet_array(@feed)
    #@tweets = Tweet.where(author_id: session[:user_id])
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
	if User.where(email: params[:email], password: params[:password]).exists?#need to implement pw hashing
	   u = User.where(email: params[:email], password: params[:password])
	   @user = u[0] #in order to become the array of fields
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
   @user = nil #? What was this for?
   if u.save
     login(params)
     redirect '/'
   else
     "There has been an error"
   end
end

# User Profile URLs and Functions #

get '/user/:user_name' do
    if User.where(user_name: params[:user_name]).exists?
      u = User.where(user_name: params[:user_name])
      @user = u[0]
      @follow_status = Follow.where(follower_id: session[:user_id], followed_id: @user.id).exists?
      @feed = Feed.get_profile_feed(@user.id)
      @tweets = Feed.prepare_tweet_array(@feed)
      erb :profile
    else
      erb :error
    end
end

post '/user/:user_name/follow' do
  follower = User.find(session[:user_id])#the person following
  followed = User.find_by_user_name(params[:user_name]) #the person being followed
  follower.following_count += 1
  followed.follower_count += 1
  f = Follow.create(follower: follower, followed: followed)
  f.save
  redirect "/user/#{params[:user_name]}"
end


post '/user/:user_name/unfollow' do
  Follow.where(follower: User.find(session[:user_id]),followed_id: User.find_by_user_name(params[:user_name])).destroy_all
  redirect "/user/#{params[:user_name]}"
end

# note the asterisk means that no matter what comes before this it will work
post '*/tweet/new/submit' do
  text = params[:tweet_text]
  i = session[:user_id]
  #author = User.find(i)
  #TweetFactory.make_tweet(text, i)
  author = User.find(session[:user_id])
  t = TweetFactory.make_tweet(text, i)#Tweet.create(text: text, author: author, author_name: author.user_name)
  f = Feed.create(user_id: session[:user_id], tweet_id: t.id, profile_feed: true)
  Feed.feed_followers(session[:user_id], t.id) #this method will post the tweet in the home_feeds of every follower of the current user
  #byebug
  redirect '/';
end


# Other #
get '/search/*' do
  erb :under_construction
end

post '/submit/' do
  erb :under_construction
end

post '/tweet/:tweet_id/like' do
  #need to keep track of which users like which tweets

end

post '/tweet/:tweet_id/unlike' do

end
