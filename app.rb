require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require 'byebug'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'


# set up the environment
#env_index = ARGV.index("-e")
#env_arg = ARGV[env_index + 1] if env_index
#env = env_arg || ENV["SINATRA_ENV"] || "development"
#databases = YAML.load_file("config/database.yml")
#ActiveRecord::Base.establish_connection(databases[env])

get '/' do
  erb :home
end

post '/submit/' do
  erb :under_construction
end

get '/login' do
  erb :login
end

post '/login/submit' do
    erb :under_construction
end

get '/logout' do
    erb :under_construction
end

get '/user/:name' do
    erb :under_construction
end

get '/registration' do
  erb :registration
end
