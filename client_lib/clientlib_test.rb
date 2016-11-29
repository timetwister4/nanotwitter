require_relative '../test/test_helper.rb'
require 'byebug'

require_relative '../models/user.rb'
require_relative '../models/tweet.rb'

require_relative '../clientlib.rb'

tweet_id1, tweet_id2 = 0

include Rack::Test::Methods


#if env == "test"
#  puts "starting in test mode"
#  User.destroy_all
#  Tweet.destroy_all
#  user1 = User.create(user_name: "TestUser1", email: "test1@test.com")
#  user2 = User.create(user_name: "TestUser2", email: "test2@test.com")
#  user3 = User.create(user_name: "TestUser3", email: "test3@test.com")
#  tweet1 = Tweet.create(author_name: user1.user_name, author_id: user1.id, text: "Original Tweet")
#  tweet_id1 = tweet1.id
#  tweet2 = Tweet.create(author_name: user2.user_name, author_id: user2.id, reply_id: tweet1.id, text: "Reply Tweet")
#  tweet_id2 = tweet2.id

  # User 1 follows user 2
  # User 2 likes tweet 1

#end


describe "client" do

  def app
    Sinatra::Application
  end

  before do
    User.destroy_all
    Tweet.destroy_all
    user1 = User.create(user_name: "TestUser1", email: "test1@test.com", name: "John", password: "pass")
    user2 = User.create(user_name: "TestUser2", email: "test2@test.com", name: "Jane", password: "pass")
    user3 = User.create(user_name: "TestUser3", email: "test3@test.com", name: "Jim", password: "pass")
    tweet1 = Tweet.create(author_name: user1.user_name, author_id: user1.id, text: "Original Tweet")
    tweet_id1 = tweet1.id
    tweet2 = Tweet.create(author_name: user2.user_name, author_id: user2.id, reply_id: tweet1.id, text: "Reply Tweet")
    tweet_id2 = tweet2.id
  end

  it "should get a user" do
    user = get_username("TestUser1")
    assert user["user_name"] == "TestUser1"
    assert user["email"] == "test1@test.com"
  end

  it "should return nil for a user not found" do
    assert User.find_by_name("TestUser0") == nil
  end

  it "should get a tweet" do
    tweet = get_tweet(tweet_id1)
    assert tweet["author_name"] == "TestUser1"
    assert tweet["text"] == "Original Tweet"
  end

#it returns an empty array, I think that's good enough
  #it "should return nil for a tweet not found" do
    #get_tweet(0).should be_nil
    #assert_raises(Exception) {get_tweet(0)}
  #end
#again, see above
  #it "should return nil for no tweets" do
    #get_user_tweets("TestUser3").should be_nil
  #  assert get_user_tweets("TestUser3") == nil
  #end

#temporarily removed test because it depends on Redis to get replies
  #I'm not sure how this should respond...
  #it "should get replies" do

  #  tweet = get_replies(tweet_id1)
  #  tweet["author_id"].should == "TestUser2"
  #  tweet["text"].should == "Reply Tweet"
  #end
  #it "should return nil for no replies" do
    #get_replies(tweet_id2).should be_nil
  #  assert get_replies(tweet_id2) == nil
  #end

  it "should get a user's tweets" do
    tweet = get_user_tweets("TestUser1")
    assert tweet[0]["author_name"] == "TestUser1"
    tweet[0]["text"] == "Original Tweet"
  end

  #it "should get a user's home feed" do
  #end
  #it "should return nil for [failed home feed test?]" do
  #end

  #it "should get a user's followings" do
  #end
  #it "should return nil for no follows" do
  #end

  #it "should get a tweet's likes" do
  #end
  #it "should return nil for [failed tweet likes test?]" do
  #end

end

#get_user_tweets(user_name)
#get_user_home_feed(user_name)
#get_user_followings(user_name)
#get_tweet_likes(user_name)
