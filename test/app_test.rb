require_relative './test_helper.rb'
require 'byebug'

require_relative '../app.rb'
require_relative '../models/user.rb'

include Rack::Test::Methods

describe "App" do

  def app
    Sinatra::Application
  end

  describe "Authentication" do



    it "can log a user in" do
      User.create(
        name: "Bjorn",
        user_name: "thunderbear",
        email: "teamthunderbeardev@gmail.com",
        password: "strongpass"
      )
      byebug
    post '/login/submit',
    {:email => "teamthunderbeardev@gmail.com",
        :password => "strongpass"}
        byebug
      assert_equal last_response.status, 302


  end

    #this test demonstrates that a user is logged out
    #by demonstrating it serves the correct page if logged out
    it "can log a user out" do
      post '/login/submit',
      {:email => "teamthunderbeardev@gmail.com",
          :password => "strongpass"}
      get '/logout'
      get '/'
      assert last_response.body.include?('<a class="btn btn-primary" href="/login">Login</a>')
    end

    it "serves correct page if logged in" do
      post '/login/submit',
      {:email => "teamthunderbeardev@gmail.com",
          :password => "strongpass"}
      get '/'
      assert last_response.body.include?("Roar")
      assert last_response.body.include?("Logout")
    end

  end

  describe "AccountCreation" do
    it "can create a user" do

    end

    it "will not create a user with a taken email" do

    end

    it "will not create a user with a taken handle" do

    end

    it "will correctly store password" do

    end
  end

  describe "Tweeting" do
    it "can save a tweet to the database" do
      Tweet.create(text: "I am toast", author: User.find(1))
      byebug
      assert (!(Tweet.find_by_text("I am toast") == nil))
    end


    it "can retrieve all tweets by a user" do
      byebug
      tweets = Tweet.find_by_author_id(1)

    end

    it "can isolate tags" do

    end

    it "can isolate mentions" do

    end

  end

  describe "Feeds" do

  end


end
