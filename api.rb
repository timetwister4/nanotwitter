require 'sinatra'
require 'sinatra/activerecord'

require 'byebug'
require_relative 'models/user'
require_relative 'models/tweet'

post'api/v1/tweets/:tweet_id' do
  Tweet.find(params[:tweet]).to_json
end

post 'api/v1/users/:user_name' do
  User.find(params[:user_id]).to_json
end

post 'api/v1/tweets/recent' do

end

post '/api/v1/users/:user_name/tweets' do
  User.where(user_name: params[:user_name])[0].tweets.to_json
end
