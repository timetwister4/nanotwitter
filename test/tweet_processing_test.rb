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
      @processor = TweetProcessor.new
      @john= User.create(name: "John", email: "john@example.com", user_name: "TestUser1", password: "strongpass")
    end

    it "replaces mentions with user URLs" do
      processed = @processor.process_text("Test text @TestUser1").value
      assert processed[0].include?("<a href=\"/user/TestUser1\">")
    end

    it "does not replace mentions if the user does not exist" do
       processed = @processor.process_text("Test text @user").value
       assert !processed[0].include?("a href=\"user/u\">")
     end

    it "replaces tags with tag search URLs" do
      processed = @processor.process_text("Test text #mike").value
      assert processed[0].include?("<a href=\"/tag/mike\">")
    end

    it "creates mentions for all mentioned users" do
     User.create(name: "Mary", user_name: "TestUser2", email: "mary@example.com", password: "strongpass")
     processed = @processor.process_text("Thanks for Beta Testing! @TestUser1 and @TestUser2").value
     assert processed[0].include?("<a href=\"/user/TestUser1\">")
     assert processed[0].include?("<a href=\"/user/TestUser2\">")
    end

    it "searches a tweet by text correctly and orders them by date correctly" do
      Tweet.delete_all
      Tweet.create(text: "1st tweet", author: @john , author_name: "TestUser1")
      Tweet.create(text: "2nd tweet", author: @john , author_name: "TestUser1")
      Tweet.create(text: "3rd tweet", author: @john , author_name: "TestUser1")
      search =@processor.search_tweets("tweet")
      assert_equal search.length , 3
      assert search[0][1].include?("3rd")
      assert search[2][1].include?("1st") 
   end



    it "searches a tweet by user_name correctly and orders them by date correctly" do
      Tweet.delete_all
      Tweet.create(text: "1st tweet", author: @john , author_name: "TestUser1")
      Tweet.create(text: "2nd tweet", author: @john , author_name: "TestUser1")
      Tweet.create(text: "3rd tweet", author: @john , author_name: "TestUser1")
      search =@processor.search_tweets("TestUser1")
      assert_equal search.length , 3
      assert search[0][1].include?("3rd")
      assert search[2][1].include?("1st") 
   end





  # it "creates tags for all tags in the tweet"

end
