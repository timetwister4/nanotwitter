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
      tweets = []
      f.each do |record|
        tweets << Tweet.find(record.tweet_id)
      end
      tweets.reverse 
 end

    #so far users do not get to see their follower
 def self.feed_followers(user,tweet) #posts the tweet that a user tweets into all the followers' feeds
  	relevant_follows = Follow.where(followed: user) #get all the follows where user being followed is the user who just posted a tweet
  	relevant_follows.each do |f| #for every relevant follow, create a feed record, by saving the id of the follower, the id of the tweet just created (by the person being followed) and make put it in their home feed!
  		u = f.follower
      HomeFeed.create(user: u, tweet: tweet)
	 end

 end



end