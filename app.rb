require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require 'byebug'


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

end

get '/login' do
  erb :login
end

post '/login/submit' do

end

get '/logout' do

end

get '/user/:name' do

end

get 'user/registration' do

end
