require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/tweet'
require_relative 'models/user'
require_relative 'models/mention.rb'
require_relative 'models/home_feed.rb'
require_relative 'feedprocessor.rb'

class TweetProcessor

  def make_tweet(text,id) #add splash param for reply information
    author = User.find(id)#get author for author fields

    #process text, get html text, list of tags, and list of mentions
    processed = process_text(text)
    t = Tweet.create(text: (processed[0]), author: author, author_name: author.user_name)
    t.save
    byebug
    author.increment_tweets 
    FeedProcessor.feed_followers(author,t)
    make_tags(processed[1], t)
    make_mentions(processed[2], t)
    return t
  end

  def process_text text

    name = String.new
    tags = Array.new
    mentions = Array.new
    words = text.split

    words.each do |w|
      if w[0] == "@"
        name = w.partition("@")[2]
        if User.where(user_name: name).exists?
          w.gsub!(w,"<a href=\"user/#{name}\">#{w}</a>")
          mentions.push(name)
        end
      elsif w[0] == "#"
        name = w.partition("#")[2]
        w.gsub!(w, "<a href=\"search/?tag=#{name}\">#{w}</a>")
        tags.push(name)
      end
    end

    text = words.join(" ")

    return text, tags, mentions

  end

  def make_tags (tag_list, tweet)
    return "Not yet implemented"
  end

  def make_mentions (mention_list, tweet)
    mention_list.each do |m|
      u = User.where(user_name: m)[0]
      m = Mention.create(user: u, tweet: tweet)
    end
  end



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
