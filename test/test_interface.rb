require 'csv'

def get_status
  time = Time.now
  users = User.all.count
  tweets = Tweet.all.count
  follows = Follow.all.count
  {:time => time, :users => users, :tweets => tweets, :follows => follows}
end

def compare_status(s_current, s_init)
  time = s_current.to_a[0][1] - s_init.to_a[0][1]
  users = s_current.to_a[1][1] - s_init.to_a[1][1]
  tweets = s_current.to_a[2][1] - s_init.to_a[2][1]
  follows = s_current.to_a[3][1] - s_init.to_a[3][1]
  {:time => time, :users => users, :tweets => tweets, :follows => follows}
end

def reset_all
  User.delete_all
  Tweet.delete_all
  #Mention.delete_all
  #Hashtag.delete_all
  #Feed.delete_all
  Follow.delete_all
end

def reset_user(name)
  user = User.where(user_name: name)
  tweet = Tweet.where(author_name: name)
  if tweet[0]
    Tweet.delete(tweet.ids)
  end
  #followers = Follow.where(follows: user).delete
  #following = Follow.where(following: user).delete
  #feed = Feed.where(owner: user).delete
  if user[0]
    User.delete(user[0].id)
  end
end

get '/test/reset/all' do
  init_status = get_status
  reset_all
  final_status = get_status
  compare_statuses(final_status, init_status).to_json
end

get '/test/reset/testuser' do
  init_status = get_status
  reset_user("TestUser")
  # Switch to User.new?
  User.create(name: "TestUser", email: "Test@Test", user_name: "TestUser", password: "Test")
  # User faker rather than static tweet
  Tweet.create(author_id: User.where(author_name: "TestUser")[0].id, author_name: "TestUser", text: "Hello!")
  get_status - init_status
end

get '/test/status' do
  get_status.to_json
end

# CSV pulls from config.ru, not from test_interface.rb
# id has to be overridden, else it increments past 1000 after table reset - alternatively, determine offset using User.all[0].id - 1, and add it to all ids
get '/test/reset/standard' do
  byebug
  init_status = get_status
  reset_all
  CSV.foreach('./test/seed_data/users.csv') do |row|
    User.create(id: row[0].to_i, name: row[1], email: "#{row[1]}@cosi105b.gov", user_name: row[1], password: "123")
  end
  
  user = User.all[0]
  CSV.foreach('./test/seed_data/tweets.csv') do |row|
    if row[0].to_i != user.id
      user = User.where(id: row[0].to_i)[0]
    end
    # May need to properly parse created_at, plus the csv is not sorted by date - is it being sorted chronologically here?
    # Alternatively, sort CSV by row[2] and *then* create tweets
    Tweet.create(author_id: row[0].to_i, author_name: user[:name], text: row[1], created_at: row[2])
    user.increment_tweets
    user.save
  end
  
  # To minimize table searches, consider parsing both CSV files row by row, if possible?
  user = User.all[0]
  CSV.foreach('./test/seed_data/follows.csv') do |row|
    if row[0].to_i != user.id
      user = User.where(id: row[0])[0]
    end
    user.increment_following
    user.save
    User.where(id: row[1].to_i)[0].increment_followers
    User.where(id: row[1].to_i)[0].save
    Follow.create(follower_id: row[0].to_i, followed_id: row[1].to_i)
  end
  
  final_status = get_status
  compare_statuses(final_status, init_status).to_json
end

get '/test/users/create?count=:count&tweets=:tweets' do
  init_status = get_status
  params[:count].times do
    #User.create()
    params[:tweets].times do
      #Tweet.create()
    end
  end
  final_status = get_status
  compare_statuses(final_status, init_status).to_json
end

get '/test/user/:user_name/tweets?count=:count' do
  init_status = get_status
  user = User.where(user_name: params[:user_name])
  if user[0]
    params[:count].times do
      #Tweet.create()
    end
  end
  final_status = get_status
  compare_statuses(final_status, init_status).to_json
end

get '/test/user/u/follow?count=n' do
end

get '/test/user/follow?count=n' do
end