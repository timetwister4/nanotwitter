require_relative "tweet.rb"
require_relative "user.rb"
require_relative "follow.rb"

class Feed <ActiveRecord::Base
  has_many :user
  has_many :tweets


  #find way to validate uniqueness of pairing

  after_initialize :set_default_values

  def set_default_values
    self.profile_feed||= false
    self.home_feed ||= false
  end


  def self.get_myhome_feed(u_id) #creates the home feed for the logged in user
  	  Feed.where(user_id: u_id, home_feed: true)
  end

  def self.get_profile_feed(u_id) #creates the profile feed of a user
  	 Feed.where(user_id: u_id, profile_feed: true)
  end

  def self.get_home_feed #creates the home feed for the unlogged user
  	 Feed.last(7) #return the last tweets in the Feed table.. right now its only shauls' tweets but when we have several users tweeting constantly it will make sense
  end

#so far users do not get to see their follower's tweets
  def self.feed_followers(u_id,t_id) #posts the tweet that a user tweets into all the followers' feeds
  	relevant_follows = Follow.where(followed_id: u_id) #get all the follows where user being followed is the user who just posted a tweet
  	relevant_follows.each do |f| #for every relevant follow, create a feed record, by saving the id of the follower, the id of the tweet just created (by the person being followed) and make put it in their home feed!
  		Feed.create(user_id: f.follower_id, tweet_id: t_id, home_feed: true)
	end

  end

  def self.prepare_tweet_array(feed_arr) #Puts all the tweets that will make up a feed in an array
  	 tweets = []
  	 feed_arr.each do |record|
  	 	tweets << Tweet.find(record.tweet_id)
  	 end
  	 tweets.reverse #if we dont reverse, we get the oldest tweets at the top pf the page..
  end


end
