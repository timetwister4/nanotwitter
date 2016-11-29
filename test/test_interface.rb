#require_relative '../app.rb'
require 'csv'
require 'faker'


get '/test/reset/all' do
  init_status = get_status
  reset_all_database
  reset_all_redis
  create_test_user
  fin_status = get_status
  @message = {:init_status => init_status, :fin_status => fin_status}
  erb :test_page

#  fin_status = get_status
#  @message = {:init_status => init_status, :fin_status => fin_status}
#  erb :test_page

end

get '/test/reset/testuser' do
  init_status = get_status
  reset_test_user
  fin_status = get_status
  @message = {:init_status => init_status, :fin_status => fin_status}
  erb :test_page
  #Switch to User.new?
  #Tweet.new(text: Faker.text)

end

get '/test/status' do
  get_status.to_json
end

# CSV pulls from config.ru, not from test_interface.rb
# id has to be overridden, else it increments past 1000 after table reset - alternatively, determine offset using User.all[0].id - 1, and add it to all ids
get '/test/reset/standard' do
<<<<<<< HEAD
  #byebug
  init_status = get_status
  reset_all_database
  reset_all_redis
  #There HAS to be a faster way to do this. This has been running for ages now.

  CSV.foreach('./test/seed_data/users.csv') do |row|
    User.create(id: row[0].to_i, name: row[1], email: "#{row[1]}@cosi105b.gov", user_name: row[1], password: "123")
  end

  user = User.all[0]
  CSV.foreach('./test/seed_data/tweets.csv') do |row|
    if row[0].to_i != user.id
      user = User.where(id: row[0].to_i)[0]
init_status = get_status
  t = Thread.new {
    #byebug
    reset_all_database
    reset_all_redis
    #There HAS to be a faster way to do this. This has been running for ages now.
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
    }
    t.abort_on_exception = true

    final_status = get_status
    compare_status(final_status, init_status).to_json
end

get '/test/users/create?count=:count&tweets=:tweets' do # ?count=:count&tweets=:tweets
  init_status = get_status
  params[:count].to_i.times do
    uname = Faker::Name.name
    user = User.create(name: uname, email: Faker::Internet.safe_email(uname), user_name: Faker::Internet.user_name(uname, %w(. _ -)), password: Faker::Internet.password)
    params[:tweets].to_i.times do
      Tweet.create(author_id: user.id, author_name: user[:user_name], text: Faker::Hacker.say_something_smart)
    end
  end
  final_status = get_status
  @message = compare_status(final_status, init_status).to_json
  erb :test_page

end

get '/test/user/:user_name/tweets?count=:count' do #
  init_status = get_status
  user = User.where(user_name: params[:user_name])
  if user[0]
    params[:count].to_i.times do
      Tweet.create(author_id: user.id, author_name: user[:user_name], text: Faker::Hacker.say_something_smart)
      user.increment_tweets
    end
  end
  final_status = get_status
  compare_status(final_status, init_status).to_json
end

get '/test/user/:user_name/follow?count=:count' do #
  user = User.where(user_name: params[:user_name])
  follows = Follow.where(followed: user)
  #Ensures user does not try to follow themself - should deny the creation, but would ultimately mean :count-1 follows
  to_follow = User.where_not("id = ? or id = ?", follows.id, user.id).order("RANDOM()").first(params[:count])
  to_follow.each do |obj|
    Follow.create(follower: obj, following: user)
    obj.increment_followings
    user.increment_followers
  end
end


#get '/test/user/follow?count=n' do
#end


def create_test_user
   User.create(name: "testuser", email: "testuser@sample.com", user_name: "testuser", password: "password")

end


def get_status
  time = Time.now
  users = User.all.count
  tweets = Tweet.all.count
  follows = Follow.all.count
# follows = Follow.all.count
  {:time => time, :users => users, :tweets => tweets, :follows => follows}
end

def reset_all_database
  User.destroy_all
  Tweet.destroy_all
  Follow.destroy_all

end

def reset_all_redis
  RedisClass.delete_keys

end


def reset_test_user
 delete_user_data(User.where(user_name: "testuser"))

end

#deletes all data related to a certain user
def delete_user_data(user)
  tweets = Tweet.where(author_name: user[0].user_name)
  tweets.destroy_all
  follows1 = Follow.where(follower: user)
  follows1.destroy_all
  follows2 = Follow.where(followed: user)
  follows2.destroy_all
  RedisClass.delete_user_keys(user[0].id)
  RedisClass.delete_user_from_follows(user[0].id)

end
  # if tweet[0]
  #   Tweet.delete(tweet.ids)
  # end
  #Follow.where(follows: user).delete
  #Follow.where(following: user).delete
  #Feed.where(owner: user).delete
def compare_status(s_current, s_init)
  time = s_current.to_a[0][1] - s_init.to_a[0][1]
  users = s_current.to_a[1][1] - s_init.to_a[1][1]
  tweets = s_current.to_a[2][1] - s_init.to_a[2][1]
  follows = s_current.to_a[3][1] - s_init.to_a[3][1]
  {:time => time, :users => users, :tweets => tweets, :follows => follows}
end
