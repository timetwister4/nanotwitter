require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'config/config_sinatra'
require 'byebug'
require_relative 'helpers/authentication.rb'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require_relative 'models/follow.rb'
require_relative 'tweetprocessor.rb'
require 'json'
require_relative 'api.rb'
#This is hard >.<

class SearchEngine



def self.search (query)
  words = query.split
  #pull out users
  text = "%#{query}%"
  full_text = Tweet.where("text LIKE ?", text)
  byebug
  users = Tweet.where(words.map{|w| {user_name: w}})
  byebug
  tags = #search for tags with all the words
  #add something to ignore "a", "the", other common words
