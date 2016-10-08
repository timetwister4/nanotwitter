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
  uri String.new
	if exist?(params[:email], params[:password])
	   u = User.where(email: params[:email], password: params[:password])
	   u = u[0] #in order to become the array of fields
     #I think instead of making instance variables of all of the fields, we should pass the array directly
     #that way if we want to add a field and use it in a page, we don't have to add it here.
	   @name = u.name
	   @email = u.email
	   @username = u.user_name
	   @followers = u.followers
	   @followings = u.following
	   @tweets = u.tweet_count

     session[:user_id] = u.id
	   erb :profile
  end

  #    uri = '/user/' + u.user_name

	 # else
	 # 	  uri = '/registration'
	 # end
  #  redirect uri
end

get '/logout' do
    erb :under_construction
end

get '/user/:name' do
    @user = User.find_by_user_name(params[:name])
    erb :profile
  end


get '/registration' do
  erb :registration
end

post '/registration/submit' do
   u = User.create(name: params[:name], email: params[:email], user_name: params[:username], password: params[:password])
   u.save
   uri = '/test/' + u.name
	redirect uri#{}"user/#{u.name}"
end

get '/test' do
  erb :home
end



  #method to check if a user exists in the database
  #if each user has a unique email, why are we checking if that password exists?
  #What if they misentered their password?
  def exist?(email,pass)
  	 User.where(email: email, password: pass).exists?
  end
