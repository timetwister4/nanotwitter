require_relative 'app.rb'
require 'byebug'
require 'typhoeus'


class ClientLibrary



	def initialize 
		#@TweetFactory = TweetProcessor.new
		@input = ''
		@user = nil
		puts "welcome to nanotwitter's client libray"
		puts "to view commands press help" 
		while @input != 'exit'
			unless @user
			   print 'nt>' 
			else
			   print "nt #{@user}>"
			end
			@input = gets.chomp 
			analyze_input
		end
		puts "thanks for using nanotwitter's client library"
	end


	#This variable does not seem to be available to api_call_no_body here

	def api_get_call(url_cont)
		  uri = "https://secret-shelf-78111.herokuapp.com/api/v1" #{}"#{ENV['SINATRA_ENV']}"
		  response = Typhoeus::Request.get(
		  	uri+"#{url_cont}"
		  )
		  if response.code == 200 && validate_response(response.body)
		    return JSON.parse(response.body)
		  else
		  	nil
		  end
	end


	def api_post_call(url_cont, params)
		 uri = "https://secret-shelf-78111.herokuapp.com/api/v1" #{}"#{ENV['SINATRA_ENV']}"
		  response = Typhoeus::Request.post(
		  	uri+"#{url_cont}",
		  	params: params
		  )
		  byebug
		  if response.code == 200 && validate_response(response.body)
		    return JSON.parse(response.body)
		  else
		  	nil
		  end
	end

	def error(word)	
		puts "command after \"#{word}\" incorrect or invalid for a logged out user"
		puts "(use the \"help\" command for instructions)"
    end


    def validate_response(body)
    	body.length != 0 && body != "null"
	end


	  #   "#{uri}/#{url_start}/#{conditional}/#{url_end}")
	  # 	 byebug
	  # if response.code == 200
	  #   return JSON.parse(response.body)
	  # elsif response.code == 404
	  #   nil
	  # else
	  #   raise response.body
	  # end


	def commands
		puts "(note: the words after the '+' sign stand for parameters)" 
		puts 'command 1: 	login (logs you into your nanotwitter account)'
		puts 'command 2: 	feed front (shows the feed of tweets in the unlogged-in homepage) '
		puts 'command 3:	tweet new + text (if you are logged in you can tweet by doing this command'
	    puts 'command 4:	tweet id (if you are logged in you can tweet by doing this command'
		puts 'command 4: 	search + string (searches for tweets that include a certain string)' 
		puts 'command 5:    feed profile (if logged in this shows your twitter profile feed) '
		puts 'command 6:    feed home (if logged in this shows your twitter home feed)'
		puts 'command 7:    feed profile + username (returns the profile feed of certain user)'
		puts 'command 8:    info (if logged in, returns the number of tweets, followers and followings'
		puts 'command 9:    info + username (returns the number of tweets, followers and followings of a certain user)'
		puts 'command 10:   followers (if logged in, returns the username of all that follow you)'
		puts 'command 11:   followers + username ( returns the username of all the people that follow a certain username)'
		puts 'command 12:   followings (if logged in, returns the username of all that you follow)'
		puts 'command 13:   followings + username (retuns the username of all the peope that a certain username follows'
		puts 'command 14:   exit (exits the program)'
		

	end

	def analyze_input
		@input = @input.split
		case
			when @input[0] == 'login' 
				login
			when @input[0] == 'help' 
				 commands
			when @input[0] == 'feed' 
				 feed
			when @input[0] == 'search'
				 search
			when @input[0] == 'tweet'
				 tweet
		    when @input[0] == 'info'
				 info
			when @input[0] ==  'followers'
				conditional("print_followers", "user_followers")
			when @input[0] == 'followings'
				conditional("print_followings", "user_followings")
			when @input[0] == 'exit'
				 exit
			else
				puts "unrecognized command"
		end

	end

	#these method takes a key word and the name of two methods (in a string). In this way we can make the analayze input method more condenesed)
	def conditional(method1, method2)
			if @user

				send(method1,@user) #takes the string with the name of the method and turns it into a method call
			else
				send(method2)
			end 
	end

	def feed
		if @input[1] == "profile"
		   if @input[2]
		   		print_tweets(api_get_call("/users/#{@input[2]}/profile-feed"))
		   elsif @user
		   		print_tweets(api_get_call("/users/#{@user}/profile-feed"))
		   end
		elsif @input[1] == "home" && @user
			  print_tweets(api_get_call("/users/#{@user}/home-feed"))
		elsif @input[1] == "front" 
			  print_tweets(api_get_call("/front-feed"))
		else
			error(@input[0])
		end
	end


	def info
		if @input[1]
		   print_info(api_get_call("/users/#{@input[1]}"))
		elsif @user
		   print_info(api_get_call("/users/#{@user}"))
		end
	end 


	def print_info(data)
		if data.nil?
			return puts "\"#{input}\" does not exist in our system"
    	else 
		   puts "username:        		   #{data["user_name"]} "
		   puts "tweet count:      		   #{data["tweet_count"]}"
		   puts "# of followers:           #{data["follower_count"]}"
		   puts "# of people following:    #{data["following_count"]}"
		end
    end
			


	def tweet 
		if @input[1] == "new" && @user
				print "tweet text: "
				text = gets.chomp
				if api_post_call("/users/#{@user}/new-tweet", {:text => text})
				   puts "tweet made succesfully"
				end
		elsif @input[1].to_i != 0
			print_tweets(api_get_call("/tweets/#{@input[1]}"))
		else
			error(@input[0])
		end
    end


	def print_tweets(tweets)
	    if tweets == nil
	    	return puts "incorrect search query"
	    elsif tweets == []
	    	return nil
	   	elsif tweets[0].class == Hash 
			 print_hash(tweets)
		else
			 print_array(tweets)
		end
	end

		def print_hash(tweets)
			  tweets.each do |tweet|
				   puts "\"#{tweet["text"]}\""
				   puts "--#{tweet["author_name"]} (#{tweet["created_at"]}) "
			   	   puts 
			   end
		end

		def print_array(tweets)
			tweets.each do |tweet|
				if tweet.class == String
            		tweet = JSON.parse(tweet)
                end
				puts "\"#{tweet[1]}\""
				puts "--#{tweet[0]} (#{tweet[2]})"
				puts 
			end
		end
	

	def login
		print "username: "
		user_name = gets.chomp
		print "password: "
		password = gets.chomp
		if api_post_call("/login", {:user_name => user_name, :password => password})
		   puts "Welcome #{user_name}, you are now logged in to nanotwitter"
		   @user = user_name
		else
		   puts "incorrect login information"
		end
	end

	def search
		print "search text: "
		search = gets.chomp
		if print_tweets(api_get_call("/tweets/#{search}/search")).nil?
			puts "no seach results for the query \"#{search}\""
		end
	end

		

	

	# def profile
	# 	tweets = RedisClass.access_pfeed(@user[0].id)
	# 	puts "#{@user[0].user_name}'s profile feed:"
	# 	print_tweets(tweets)

	# end

	# def home
	# 	tweets = RedisClass.access_hfeed(@user[0].id)
	# 	puts "#{@user[0].user_name}'s home feed:"
	# 	print_tweets(tweets)

	# end

	# def user_profile
	# 	if User.where(user_name: @input[1]).exists?
	# 		u = User.where(user_name: @input[1])
	# 		tweets = RedisClass.access_pfeed(u[0].id)
	# 		puts "#{u[0].user_name}'s profile feed:"
	# 		print_tweets(tweets)
	# 	end
	# end

	
	# def user_info
	# 	if User.where(user_name: @input[1]).exists?
	# 		print_info(User.where(user_name: @input[1]))
	# 	else
	# 		puts "username does not exist"
	# 	end
	# end

	# def print_info(user)
	# 		puts "# of people #{user[0].user_name} follows: #{user[0].follower_count}"
	# 		puts "# of people following #{user[0].user_name}: #{user[0].following_count}"
	# 		puts "# of tweets #{user[0].user_name} has: #{user[0].tweet_count}"
	# end
	
	#THE 4 METHODS THAM COME NOW NEED TO BE CONDENSED INTO TWO METHODS
	def print_followers(user)
		ids = RedisClass.access_followers(user[0].id)
		ids.each do |id|
			puts "#{User.find(f.to_i).user_name}"
		end
	end



	def user_followers
		if User.where(user_name: @input[1]).exists?
	 		u = User.where(user_name: @input[1])
	 		print_followers(u)
	 	end
	 end

	 def print_followings(user)
		ids = RedisClass.access_followings(user[0].id)
		ids.each do |id|
			puts "#{User.find(f.to_i).user_name}"
		end
	end

	def user_followings
		if User.where(user_name: @input[1]).exists?
	 		u = User.where(user_name: @input[1])
	 		print_followings(u)
	 	end
	 end



	
		# tweets.each do |t|
		# 	 t = JSON.parse(t)
	 #   		puts "#{t["created_at"]}: #{t["text"]} , #{t["author_name"]}"
			
		# end

end

ClientLibrary.new