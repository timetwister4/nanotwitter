require_relative './test_helper.rb'
require 'byebug'

require_relative '../models/user.rb'
require_relative '../models/tweet.rb'

describe "Database" do

  def app
    Sinatra::Application
  end

  describe "Users" do

    before (:each) do
      User.delete_all
      User.create(
        name: "Bjorn",
        user_name: "thunderbear",
        email: "teamthunderbeardev@gmail.com",
        password: "strongpass"
      )
    end

    it "can create a user" do

      assert User.where(
        name: "Bjorn",
        user_name: "thunderbear",
        email: "teamthunderbeardev@gmail.com").exists?
    end

    it "will not create a user with a duplicate user_name" do
      User.create(
        name:"John",
        user_name: "thunderbear",
        email: "john@example.com",
        password: "strongpass"
      )

      assert !User.where(
        name: "John",
        user_name: "thunderbear").exists?
    end

    it "will not create a user with a duplicate email" do
      User.create(
        name: "John",
        user_name: "TestUser2",
        email: "teamthunderbeardev@gmail.com",
        password: "strongpass"
      )
      assert !User.where(name: "John", email:"teamthunderbeardev@gmail.com").exists?

    end

    it "will not create a user without a password" do
      User.create(
        name: "John",
        user_name: "TestUser3",
        email: "john@example.com"
      )
      assert !User.where(user_name: "TestUser3").exists?
    end

    it "initializes tweet count to zero" do
      assert_equal(User.where(name: "Bjorn")[0].tweet_count, 0)
    end

    it "initializes follower count to zero" do
      assert_equal(User.where(name: "Bjorn")[0].follower_count, 0)
    end

    it "initializes following count to zero" do
      assert_equal(User.where(name: "Bjorn")[0].following_count, 0)
    end

    it "can increment the number of followers" do
      u = User.where(user_name: "thunderbear")
      u[0].increment_followers
      assert_equal(u[0].follower_count, 1)
    end

    it "can decrement the number of followers" do
      u = User. where(user_name: "thunderbear")
      u[0].increment_followers
      u[0].decrement_followers
      assert_equal(u[0].follower_count, 0)
    end
  end

  describe "Tweets" do

    before(:each) do
      Tweet.destroy_all
      User.destroy_all
      u = User.create(name: "Bjorn", user_name: "thunderbear", email: "teamthunderbeardev@gmail.com", password: "strongpass")
      Tweet.create(text: "Test Text", author: u)
    end

    it "can store tweet to database" do
        t = Tweet.create(text: "Test Text2", author: User.where(user_name: "thunderbear")[0])
        assert Tweet.where(text: "Test Text2").exists?
    end

    it "must have has an author" do
     t = Tweet.create(text: "Test Text 3")
     assert !t.valid?
    end

    it "must contain text" do
      t = Tweet.create(author: User.where(user_name: "BearHammer")[0])
      assert !t.valid?
    end

    it "initializes likes to 0" do
      t = Tweet.create(text: "Test Text 4", author: User.where(user_name: "BearHammer")[0])
      assert_equal(t.likes, 0)
    end

    it "can increment likes" do
        t = Tweet.where(text: "Test Text")[0]
        starting_likes = t.likes
        t.increment_likes
        assert starting_likes < t.likes
    end

    it "can decrement likes" do
      t = Tweet.where(text: "Test Text")[0]
      starting_likes = t.increment_likes #ensures that likes is > 0
      t.decrement_likes
      assert starting_likes > t.likes

    end

    it "will not decrement likes if likes = 0" do
      t = Tweet.where(text: "Test Text")[0]
      while(t.likes > 0)
        t.decrement_likes
      end
      t.decrement_likes
      assert_equal(t.likes, 0)
    end

    describe "replies" do
      it "is a reply" do

      end

      it "connects to what it replies to" do

      end

      it "initializes replies to false if not a reply" do

      end
    end


  end
  describe "follow" do
    before(:each) do
      User.create(name: "John", user_name: "TestUser4", email: "j@example.com", password: "strongpass")
      User.create(name: "Mary", user_name: "TestUser5", email: "m@example.com", password: "strongpass")
    end

    it "can create a follow between users" do

    end

    it "prevents duplicate follows" do

    end

    it "can delete a follow" do

    end

    it "must have a follower" do

    end

    it "must have a followed user" do

    end

  end


end
