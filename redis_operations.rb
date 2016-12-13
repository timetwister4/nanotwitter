require 'redis'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require_relative 'models/follow.rb'
require 'json'
require 'byebug'

class RedisClass
	
	def self.cache_tweet(tweet,user_id)
		if $redis.lrange("ffeed", 0, -1).length == 50
		   $redis.rpop("ffeed")
		   $redis.lpush("ffeed", tweet.to_json)
		else
		   $redis.lpush("ffeed", tweet.to_json)
		end
		$redis.lpush("user:#{user_id}:pfeed", tweet.to_json) #cache tweet for self
		followers = Follow.where(followed_id: user_id)
		followers.each do |follow|
			$redis.lpush("user:#{follow.follower_id}:hfeed", tweet.to_json)
		end

	end
	
	def self.access_pfeed(u_id)
		$redis.lrange("user:#{u_id}:pfeed", 0, -1) #return the unparsed tweets of your nt profile
	end

	def self.access_hfeed(u_id)
		$redis.lrange("user:#{u_id}:hfeed", 0, -1) #return the unparsed tweets of your nt profile
	end

	def self.access_ffeed
		$redis.lrange("ffeed",0,-1)
	end

	def self.cache_reply(reply, tweet_id)
		$redis.rpush("tweet:#{tweet_id}:replies", reply.to_json)
	end

	def self.access_replies(tweet_id)
		replies = $redis.lrange("tweet:#{tweet_id}:replies", 0, -1)
		output	= []
		replies.each do |reply|
			output << JSON.parse(reply)
		end
		output
	end

	def self.cache_mentions(ids,tweet, user_id)
		followers = Follow.where(followed_id: user_id)
		followers.each do |follow| #This is to prevent a tweet of replicating itself in a persons wall
			if ids.include?(follow.follower_id)
			   ids.delete(follow.follower_id)
			end 
		end
		ids.each do |id|
			$redis.lpush("user:#{id}:hfeed", tweet.to_json)
		end
	end

	def self.cache_tags(tags, tweet)
		tags.each do |t|
			$redis.lpush("tag:#{t}", tweet.to_json)
		end
	end
	
	def self.access_tag(name)
		$redis.lrange("tag:#{name}", 0, -1)
	end

	def self.cache_likes(u_id,t_id) #we need to store likes so that a user cannot like the tweet two times
	 	$redis.sadd("tweet:#{t_id}:likes", u_id)
	end

	def self.liked_before?(u_id, t_id)
		$redis.sismember("tweet:#{t_id}:likes", u_id)
	end

	def self.number_of_keys
		$redis.dbsize
	end

	def self.delete_keys
		$redis.flushdb
	end

	def self.delete_user_keys(id)
		$redis.del("user:#{id}:hfeed")
		$redis.del("user:#{id}:pfeed")
		$redis.del("user:#{id}:followings")
		$redis.del("user:#{id}:followers")
	end

	def self.delete_ffeed
		$redis.del("ffeed")
	end

	
end
