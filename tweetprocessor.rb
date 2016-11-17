require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/tweet'
require_relative 'models/user'
require_relative 'redis_operations.rb'

class TweetProcessor

  def make_tweet(text,id) #add splash param for reply information
    author = User.find(id)#get author for author fields

    #process text, get html text, list of tags, and list of mentions
    processed = process_text(text)
    t = Tweet.create(text: (processed[0]), author: author, author_name: author.user_name)
    t.save
    author.increment_tweets #check what each of the processed parameters are.
    RedisClass.cache_tweet(t, id, t.id)
    if processed[1].length > 0
       RedisClass.cache_mentions(processed[1], t)
    elsif processed[2].length > 0
       RedisClass.cache_tags(processed[2],t)
    end
    
    #FeedProcessor.feed_followers(author,t)
    # make_tags(processed[1], t)
    # make_mentions(processed[2], t)
    return t
  end

  def process_text(text)

    name = String.new
    tags = Array.new
    mentions = Array.new
    words = text.split

    words.each do |w|
      if w[0] == "@"
        name = w.partition("@")[2]
        u = User.where(user_name: name)
        if (u != [])
          w.gsub!(w,"<a href=\"user/#{name}\">#{w}</a>")
          mentions.push(u.id)
        end
      elsif w[0] == "#"
        name = w.partition("#")[2]
        w.gsub!(w, "<a href=\"tag/#{name}\">#{w}</a>")
        tags.push(name)
      end
    end

    text = words.join(" ")

    return text, tags, mentions

  end

  #####issues that we need to deal with: ######
  #how do we do so that a tweet doesn't get duplicated when you mention someone that is also following you?




  # def make_tags (tag_list, tweet)
  #   return "Not yet implemented"
  # end

  # def make_mentions (mention_list, tweet)
  #   m = mention_list.map{|u| {user: u, tweet: tweet} }
  #   Mention.create(m)
  # end


  #make less hacky
  def search_tweets(keyword)
    query_tweets = []
    all_tweets = Tweet.order("created_at DESC")
    all_tweets.each do |tweet|
      if tweet.author_name == keyword  || tweet.text.include?(keyword)
          query_tweets << tweet
      end
    end
    query_tweets
  end


end
