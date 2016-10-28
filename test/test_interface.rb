def get_status
  time = Time.now
  users = User.all.count
  tweets = Tweet.all.count
# follows = Follow.all.count
  {:time => time, :users => users, :tweets => tweets}
end

def reset_all
  User.delete_all
  Tweet.delete_all
  #Feed.delete_all
  #Follow.delete_all
end

def reset_user(name)
  user = User.where(user_name: name)
  tweet = Tweet.where(author_name: name)
  if tweet[0]
    Tweet.delete(tweet.ids)
  end
  #Follow.where(follows: user).delete
  #Follow.where(following: user).delete
  #Feed.where(owner: user).delete
  if user[0]
    byebug
    User.delete(user[0].id)
  end
end

get '/test/reset/all' do
  init_status = get_status
  reset_all
  final_status = get_status
  (init_status - final_status).to_json
end

get '/test/reset/testuser' do
  init_status = get_status
  reset_user("TestUser")
  #Switch to User.new?
  User.create(name: "TestUser", email: "Test@Test", user_name: "TestUser", password: "Test")
  #Tweet.new(text: Faker.text)
end

get '/test/status' do
  get_status.to_json
end

get '/test/reset/standard' do
end

get '/test/users/create?count=u&tweets=c' do
end

get '/test/user/u/tweets?count=t' do
end

get '/test/user/u/follow?count=n' do
end

get '/test/user/follow?count=n' do
end