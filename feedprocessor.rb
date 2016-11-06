require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/user.rb'
require_relative 'models/home_feed.rb'
require_relative 'models/follow.rb'


class FeedProcessor

def self.get_myhome_feed(u_id) #creates the home feed for the logged in user
  	  u = User.find(u_id)
      f = HomeFeed.where(user: u)
      prepare_tweets(f)
 end

    #so far users do not get to see their follower
 def feed_followers(user,tweet) #posts the tweet that a user tweets into all the followers' feeds
  	relevant_follows = Follow.where(followed_id: session[:user_id]) #get all the follows where user being followed is the user who just posted a tweet
  	relevant_follows.each do |f| #for every relevant follow, create a feed record, by saving the id of the follower, the id of the tweet just created (by the person being followed) and make put it in their home feed!
  		HomeFeed.create(user: user, tweet: tweet)
	 end

 end


  def prepare_tweets(feed_arr) #Puts all the tweets that will make up a feed in an array
  	 tweets = []
  	 feed_arr.each do |record|
  	   	tweets << Tweet.find(record.tweet_id)
  	 end
  	 tweets.reverse #if we dont reverse, we get the oldest tweets at the top pf the page..
  end


end