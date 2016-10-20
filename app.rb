require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'config/config_sinatra'
require 'byebug'
require_relative 'helpers/authentication.rb'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'




def login (params)
  if User.where(email: params[:email], password: params[:password]).exists?
	   u = User.where(email: params[:email], password: params[:password])
     @user = u[0] #in order to become the array of fields
     session[:user_id] = @user.id
     session[:expires_at] = Time.current + 10.minutes
     return session
  else
    return nil
  end
end

get '/' do
  if authenticate!
    u = User.where(id: session[:user_id])
    @user = u[0]
    erb :my_home #personalized homepage
  else
    erb :home #a generic homepage
  end

end

post '/submit/' do
  erb :under_construction
end

get '/login' do
  erb :login
end

post '/login/submit' do
	if User.where(email: params[:email], password: params[:password]).exists?
	   u = User.where(email: params[:email], password: params[:password])
	   @user = u[0] #in order to become the array of fields
     session[:user_id] = @user.id
     session[:expires_at] = Time.current + 10.minutes
     redirect '/'
  else
     redirect '/registration'
  end
end


get'/logout' do
    log_out_now
    redirect '/'
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


get '/registration/?' do
  erb :registration
end

post '/registration/submit' do
   u = User.create(name: params[:name], email: params[:email], user_name: params[:username], password: params[:password])
   @user = nil
   if u.save
     login(params)
     redirect '/'
   else
     "There has been an error"
   end
   #redirect '/user/' + u[:user_name]
end

get '/tweet/new' do
  erb :under_construction
end

#the asterisk means that no matter what comes before this it will work
post '*/tweet/new/submit' do
  text = params[:roar_text]
  i = session[:user_id]
  byebug
  author = User.find(i)
  t=Tweet.create(text: text, author: author )
  t.save
  byebug
end
