require 'typhoeus'
require 'json'

uri = "#{ENV['SINATRA_ENV']}"

def api_call_no_body(url_start, conditional, url_end)
  response = Typhoeus::Request.post(
    "#{base_uri}/#{url_start}/#{conditional}/#{url_end}")
  if response.code == 200
    JSON.parse(response.body)
  elsif response.code == 404
    nil
  else
    raise response.body
  end
end

# Get tweet by ID
# api/v1/tweets/:tweet_id
def get_tweet(tweet_id)
  api_call_no_body("api/v1/tweets", tweet_id)
end

# Get usernames by ID
# api/v1/users/:user_name
def get_username(user_name)
  api_call_no_body("api/v1/users", user_name)
end

# Get tweet replies by original ID
# api/v1/tweets/:tweet_id/replies
def get_replies(tweet_id)
  api_call_no_body("api/v1/tweets", tweet_id, "replies")
end

# (This should be called with a JSON body)
# Get tweets by username ID
# api/v1/users/:user_name/tweets
def get_user_tweets(user_name)
  api_call_no_body("api/v1/users", user_name, "tweets")
end

# (This should be called with a JSON body)
# Get tweets by tag
# api/v1/tag/:tag_name

# (This should be called with a JSON body)
# Get user's home feed (login?)
# api/v1/users/:user_name/home_feed
def get_user_home_feed(user_name)
  api_call_no_body("api/v1/users", user_name, "home_feed")
end

# Get user followings
# api/v1/follows/:user_name/followings
def get_user_followings(user_name)
  api_call_no_body("api/v1/users", user_name, "followings")
end

# Get tweet likes
# api/v1/tweets/:tweet_id/likes
def get_tweet_likes(user_name)
  api_call_no_body("api/v1/tweets", tweet_id, "likes")
end