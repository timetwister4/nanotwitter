require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/tweet'

class TweetProcessor


  def make_tweet (text, author_id, reply*)
    author = User.find(author_id)
    t = Tweet.create(text: (make_links text), author: author, author_name: author.user_name)
  end

  def make_links text
    name = String.new
    words = text.split
    words.each do |w|
      if w[0] == "@"
        name = w.partition("@")[2]
        w.gsub!(w,"<a href=\"user\\#{name}\">#{w}<\\a>" )
      elsif w[0] == "#"
        tag = w.partition("#")[2]
        w.gsub!(w, "a href=\"search\\?tag=#{tag}")
        puts "it is not a mention"
      end
    end
    puts text
    puts words
    text = words.join(" ")
    puts text

  end

  def replace_with_link

  end

  end
