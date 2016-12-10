require_relative './test_helper.rb'
require 'byebug'

require_relative '../models/user.rb'
require_relative '../models/tweet.rb'
#require_relative '../models/mention.rb'
require_relative '../tweetprocessor.rb'

describe "Tweet Processor" do

  def app
    Sinatra::Application
  end

  before(:each) do
    User.destroy_all
  end

  # it "replaces mentions with user URLs" do
  #   t = TweetProcessor.new
  #   User.create(name: "John", email: "john@example.com", user_name: "TestUser", password: "strongpass")
  #   processed_tweet = t.process_text("Test text @TestUser")
  #   assert processed_tweet[0].include?("<a href=\"/user/TestUser\">")
  # end

  # it "does not replace mentions if the user does not exist" do
  #   t = TweetProcessor.new
  #   user_exists = User.where(user_name: "RubyHater").exists?
  #   processed_tweet = t.process_text("No one hates ruby, @RubyHater")
  #   assert !user_exists && !processed_tweet[0].include?("a href=\"user/RubyHater\">")
  # end

  # it "replaces tags with tag search URLs" do
  #   t = TweetProcessor.new
  #   processed_tweet = t.process_text("I love Ruby #Ruby")
  #   assert processed_tweet[0].include?("<a href=\"search/tag=Ruby\">")
  # end

  #it "creates mentions for all mentioned users" do
  #  u = User.create(name: "Mary", user_name: "TestUser", email: "mary@example.com", password: "strongpass")
  #  v = User.create(name: "John", user_name: "TestUser2", email: "john@example.com", password: "strongpass")
  #  t = TweetProcessor.new
  #  tweet = t.make_tweet("Thanks for Beta Testing! @TestUser and @TestUser2", u.id)
  #  assert Mention.where(user: u).exists? && Mention.where(user: v).exists?
  #end

  #it "creates tags for all tags in the tweet"

end
