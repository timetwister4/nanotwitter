require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/tweet'
require_relative 'models/user'
require_relative 'redis_operations.rb'

class TweetProcessor

  def make_tweet(text,id,reply_id)
      init = Time.now
      user = User.find(id)
      processed = process_text(text)
      Thread.new {
            t = Tweet.create(text: (processed.value[0]), author: user, author_name: user.user_name)
            tweet = [user.user_name, processed.value[0], t.created_at, t.id]
            if reply_id.nil?
                user.increment_tweets
                RedisClass.cache_tweet(tweet,user.id,t.id)
            else
                RedisClass.cache_reply(tweet,reply_id)
            end
            if processed.value[1].length > 0
               RedisClass.cache_mentions(processed.value[1],tweet,id)
            elsif processed.value[2].length > 0
               RedisClass.cache_all_tags(processed.value[2],tweet)
            end
      }
   

  end

  def process_text(text) #checks to see if there any tags or mentions, and if there are, it makes a link out of them.
      Thread.new {
          name = String.new
          tags = Array.new
          mentions = Array.new
          words = text.split
          words.each do |w|
                if w[0] == "@"
                    name = w.partition("@")[2]
                    u = User.where(user_name: name)
                    if (u != [])
                      w.gsub!(w,"<a href=\"/user/#{name}\">#{w}</a>")
                      mentions.push(u[0].id)
                    end
                elsif w[0] == "#"
                    name = w.partition("#")[2]
                    w.gsub!(w, "<a href=\"/tag/#{name}\">#{w}</a>")
                    tags.push(name)
                end
         end
         text = words.join(" ")
         [text,mentions,tags]
      }
        
  end


  def search_tweets(keyword)
      thr = Thread.new{
            query_tweets = []
            all_tweets = Tweet.order("created_at DESC")
            all_tweets.each do |t|
                if t.author_name == keyword  || t.text.include?(keyword)
                      query_tweets << [t.author_name,t.text,t.created_at,t.id,t.likes]
                end
            end
            query_tweets
    
      }
      thr.value
  end
    
end

