require 'redis'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require 'json'
require 'byebug'

class RedisClass

	def self.cache_follow(user_id, person_followed)
		$redis.sadd("user:#{user_id}:follows", person_followed)
	end

	def self.cache_unfollow(user_id, person_unfollowed)
		$redis.srem("user:#{user_id}:follows", person_unfollowed)
	end

	def self.cache_general(user)
		$redis.set("user:#{user.id}:general", user.to_json)

	end

	def self.cache_tweet(tweet,user_id, tweet_id)
		$redis.sadd("tweet:#{tweet_id}", tweet.to_json)
		$redis.rpush("user:#{user_id}:pfeed", tweet.to_json) #cache tweet for self
		followers = $redis.smembers("user:#{user_id}:follows")
		followers.each do |f_id|
			$redis.rpush("user:#{f_id}:hfeed", tweet.to_json)
		end
	end

	def self.cache_reply(reply, tweet_id)
		$redis.rpush("tweet:#{tweet_id}:replies", reply.to_json)
	end

	def self.cache_mentions(users_ids, tweet)
		users_ids.each do |id|
			$redis.rpush("user:#{id}:mentions", tweet.to_json)
		end
	
	end

	def self.cache_tags(tag_names, tweet)
		tag_names do |name|
			$redis.rpush("tag:#{name}", tweet.to_json)

		end

	end

	def self.cache_likes(t_id, u_id, t) #we need to store likes so that a user cannot like the tweet two times
	    if $redis.sismember("tweet:#{t_id}:likes", u_id) == false
			$redis.sadd("tweet:#{t_id}:likes", u_id)
			t.increase_likes
			return true
		end
	end


	def self.access_general(u_id)

	end


	def self.access_pfeed(u_id)
		$redis.lrange("user:#{u_id}:pfeed", 0, -1) #return the unparsed tweets of your nt profile

	end




	def self.access_hfeed(u_id)
	    $redis.lrange("user:#{u_id}:hfeed",0, -1) #returns the unparsed tweets (in json format)
		
	end

	def self.access_tag(name)
		$redis.lrange("tag:#{name}", 0, -1)

	end

	def self.access_replies(tweet_id)
		$redis.lrange("tweet:#{tweet_id}:replies", 0, -1)
	end



	

end
