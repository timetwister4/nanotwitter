require_relative './test_helper.rb'
require 'byebug'

include Rack::Test::Methods

describe "Redis" do


	def app
	    Sinatra::Application
	end

	describe "Feeds" do
		
		
		before(:each) do
			 User.delete_all
			 Follow.delete_all
			 Tweet.delete_all
			 RedisClass.delete_keys
			 @john = User.create(name: "John", user_name: "TestUser2", email:"john@example.com", password: "strongpass")
			 @peter = User.create(name: "Peter", user_name: "TestUser3", email:"peter@example.com", password: "strongpass")
			 @micheal = User.create(name: "micheal", user_name: "TestUser4", email:"peter@example.com", password: "strongpass")
			 @tweet = ["TestUser4","Hello","12.10.16 6.30pm",1]
		end

		it "checks that keys are 0" do
			$redis.dbsize == 0
		end

		it "caches a tweet correctly" do
			RedisClass.cache_tweet(@tweet,@john.id)
			!RedisClass.access_pfeed(@john.id).nil?
			!RedisClass.access_ffeed(@john.id).nil?
		end


	end






end