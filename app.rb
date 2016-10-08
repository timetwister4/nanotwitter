require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './config/config_sinatra'
require 'byebug'
require_relative 'helpers/authentication.rb'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'


# set up the environment
#env_index = ARGV.index("-e")
#env_arg = ARGV[env_index + 1] if env_index
#env = env_arg || ENV["SINATRA_ENV"] || "development"
#databases = YAML.load_file("config/database.yml")
#ActiveRecord::Base.establish_connection(databases[env])

get '/' do
  @current_user = current_user
  erb :home

end

post '/submit/' do
  erb :under_construction
end

get '/login' do
  erb :login
end

post '/login/submit' do
	if exist?(params[:email], params[:password])
	   u = User.where(email: params[:email], password: params[:password])
	   u = u[0] #in order to become the array of fields
	   @name = u.name
	   @email = u.email
	   @username = u.user_name
	   @followers = u.followers
	   @followings = u.following
	   @tweets = u.tweet_count
     session[:user_id] = u.id
	   erb :profile
	 else
	 	erb :registration
	 end
end

get '/logout' do
    erb :under_construction
end


get '/registration' do
  erb :registration
end

post '/registration/submit' do
   u = User.create(name: params[:name], email: params[:email], user_name: params[:username], password: params[:password])
   u.save
   @name = u.name
   @email = u.email
   @username = u.user_name
   @followers = u.followers
   @followings = u.following
   @tweets = u.tweet_count

	erb :profile
end




  #method to check if a user exists in the database
  def exist?(email,pass)
  	 User.where(email: email, password: pass).exists?
  end
