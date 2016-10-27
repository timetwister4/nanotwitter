require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/tweet'

class TweetProcessor

  def make_tweet(text, author_id) #add splash param for reply information
    author = User.find(author_id)#get author for author fields
    #process text, get html text, list of tags, and list of mentions
    processed = process_text(text)
    t = Tweet.create(text: (processed(text)[0]), author: author, author_name: author.user_name)
    t.save
    make_tags(processed[1], t)
    make_mentions(processed[2], t)
  end

  def process_text text
    name = String.new
    tags = Array.new
    mentions = Array.new
    words = text.split

    words.each do |w|
      if w[0] == "@"
        name = w.partition("@")[2]
        w.gsub!(w,"<a href=\"user\\#{name}\">#{w}<\\a>")
        mentions.push(name)
      elsif w[0] == "#"
        name = w.partition("#")[2]
        w.gsub!(w, "a href=\"search\\?tag=#{name}")
        tags.push(name)
      end
    end

    text = words.join(" ")

    return text, tags, mentions

  end

  def make_tags
    return "Not yet implemented"
  end

  def make_mentions
    return "Not Yet Implemented"
  end


  end
