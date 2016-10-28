require_relative 'app.rb'

get '/test/reset/all' do
  init_status = get_status
  reset_all
  fin_status = get_status
  @message = {:init_status => init_status, :fin_status => fin_status}
  erb :test_page
end

get '/test/reset/testuser' do
  init_status = get_status
  reset_user
  fin_status = get_status
  @message = {:init_status => init_status, :fin_status => fin_status}
  erb :test_page
  #Switch to User.new?
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


def create_test_user
   User.create(name: "TestUser", email: "Test@Test", user_name: "TestUser", password: "Test")

end


def get_status
  time = Time.now
  users = User.all.count
  tweets = Tweet.all.count
  follows = Follow.all.count
# follows = Follow.all.count
  {:time => time, :users => users, :tweets => tweets, :follows => follows}
end

def reset_all
  User.destroy_all
  Tweet.destroy_all
  Follow.destroy_all
  #Feed.delete_all
  #Follow.delete_all
end

def reset_user(name)
  user = User.where(user_name: "TestUser")
  tweet = Tweet.where(author_name: "TestUser")
  
  # if tweet[0]
  #   Tweet.delete(tweet.ids)
  # end
  #Follow.where(follows: user).delete
  #Follow.where(following: user).delete
  #Feed.where(owner: user).delete