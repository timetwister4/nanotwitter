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
  authenticate!
  erb :home

end

post '/submit/' do
  erb :under_construction
end

get '/login' do
  erb :login
end

post '/login/submit' do
  #uri String.new
	if User.where(email: params[:email], password: params[:password]).exists?
	   u = User.where(email: params[:email], password: params[:password])
	   @user = u[0] #in order to become the array of fields
     session[:user_id] = @user.id
	   erb :profile
  else
     erb :registration
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

get '/user/:user_name' do
    authenticate!
    if User.where(user_name: params[:user_name]).exists?
      u = User.where(user_name: params[:user_name])
      @user = u[0]
      erb :profile
    else
      erb :error
    end
end


get '/registration' do
  erb :registration
end

post '/registration/submit' do
   u = User.create(name: params[:name], email: params[:email], user_name: params[:username], password: params[:password])
   u.save
   @user = u 
   erb :profile

 #   uri = '/test/' + u.name
	# redirect uri#{}"user/#{u.name}"

end



