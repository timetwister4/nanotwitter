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

    it "can store tweet to database" do

    end

    it "must have has an author" do

    end

    it "must contain text" do

    end

    it "initializes likes to 0" do

    end

    it "can increment likes" do

    end

    it "can decrement likes" do

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



end
