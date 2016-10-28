require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'config/config_sinatra'
require 'byebug'
require_relative 'helpers/authentication.rb'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require_relative 'models/follow.rb'

get '/loaderio-accded2323af55270a8895980c841782.txt' do
  send_file 'loaderio-accded2323af55270a8895980c841782.txt'
end


#consider moving this to the authentication helper.

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


#root
get '/' do
  if authenticate!
    u = User.where(id: session[:user_id])
    @user = u[0]
    @tweets = Tweet.where(author_id: session[:user_id])
    #byebug
    erb :my_home #personalized homepage
  else
    erb :home #a generic homepage
  end
end

# Login URLs #
get '/login' do
  erb :login
end

post '/login/submit' do
	if User.where(email: params[:email], password: params[:password]).exists?#need to implement pw hashing
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

# Account Registration URLs #

get '/registration/?' do
  erb :registration
end

post '/registration/submit' do
   u = User.create(name: params[:name], email: params[:email], user_name: params[:user_name], password: params[:password])
   @user = nil #? What was this for?
   if u.save
     login(params)
     redirect '/'
   else
     "There has been an error"
   end
end

# User Profile URLs and Functions #

get '/user/:user_name' do
    if User.where(user_name: params[:user_name]).exists?
      u = User.where(user_name: params[:user_name])
      @user = u[0]
      @follow_status = Follow.where(follower_id: session[:user_id], followed_id: u[0].id).exists?
      erb :profile
    else
      erb :error
    end
end

post '/user/:user_name/follow' do
  follower = User.find(session[:user_id])#the person following
  followed = User.find_by_user_name(params[:user_name]) #the person being followed
  f = Follow.create(follower: follower, followed: followed)
  f.save
  redirect "/user/#{params[:user_name]}"
end
#note, consider storing followed users in the user's session cookie?
#add to it when they add a follower

post '/user/:user_name/unfollow' do
  #follow = Follow.where(follower: User.find(session[:user_id]),followed_id: User.find_by_user_name(params[:user_name]))
  Follow.where(follower: User.find(session[:user_id]),followed_id: User.find_by_user_name(params[:user_name])).destroy_all
  redirect "/user/#{params[:user_name]}"
end

get '/tweet/new' do
  erb :under_construction
end

#t note the asterisk means that no matter what comes before this it will work
post '*/tweet/new/submit' do
  text = params[:tweet_text]
  i = session[:user_id]
  author = User.find(i)
  t=Tweet.create(text: text, author: author, author_name: author.user_name)
  t.save
  #byebug
  redirect '/';
end


# Other #
get '/search/*' do
  erb :under_construction
end

post '/submit/' do
  erb :under_construction
end

post '/tweet/:tweet_id/like' do

end

post '/tweet/:tweet_id/unlike' do

end
