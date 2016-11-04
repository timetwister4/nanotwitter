require 'sinatra'
require 'sinatra/activerecord'

require 'byebug'
require 'model/user'
require 'models/tweet'

get 'api/v1/tweets/:tweet_id' do
  Tweet.find(params[:tweet]).to_json
end

get 'api/v1/users/:user_id' do
  User.find(params[:user_id]).to_json
end

get 'api/v1/tweets/recent' do

end

get 'api/v1/users/:user_id/tweets' do

end
