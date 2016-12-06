require_relative './test_helper.rb'
require 'byebug'

require_relative '../models/user.rb'

include Rack::Test::Methods

describe "App" do

  def app
    Sinatra::Application
  end

  describe "Authentication" do

    before(:each) do
      User.create(
        name: "Bjorn",
        user_name: "thunderbear",
        email: "teamthunderbeardev@gmail.com",
        password: "strongpass"
      )
    end

    it "can log a user in" do
      post '/login/submit',
      {:email => "teamthunderbeardev@gmail.com",
          :password => "strongpass"}
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
      assert !last_response.body.include?('<a class="btn btn-primary" href="/logout">Logout</a>')
    end

    it "serves correct page if logged in" do
      post '/login/submit',
      {:email => "teamthunderbeardev@gmail.com",
          :password => "strongpass"}
      get '/'
      assert last_response.body.include?("Logout")
    end

  end

  describe "AccountCreation" do
    before(:each)do
      User.delete_all
      User.create(name: "John", user_name: "TestUser2", email:"john@example.com", password: "strongpass")
    end

    it "can register a user" do
      already_existed = User.where(name: "Bjorn", user_name:"BearHammer", email: "teamthunderbeardev@gmail.com").exists?
      post 'registration/submit', {name: "Bjorn", user_name:"BearHammer", email: "teamthunderbeardev@gmail.com", password: "strongpass"}
      assert !already_existed #the user didn't exist before the test, therefore it as just created
      assert User.where(name: "Bjorn", user_name:"BearHammer", email: "teamthunderbeardev@gmail.com").exists?
    end

    it "will not create a user with a taken email" do #consider "It will alert the user that the email is taken? "
      email_taken = User.where(email: "john@example.com").exists?
      post 'registration/submit', {name: "Bjorn", user_name:"BearHammer", email: "john@example.com", password: "strongpass"}
      assert email_taken
      assert !User.where(user_name: "BearHammer", email: "john@example.com").exists?
    end

    it "will not create a user with a taken username" do
      user_name_taken = User.where(user_name: "TestUser2").exists?
      post 'registration/submit',
      {name: "Bjorn",
        user_name:"TestUser2",
         email: "teamthunderbeardev@gmail.com",
         password: "strongpass"}
      assert user_name_taken
      assert !User.where(user_name: "TestUser2", email: "teamthunderbeardev@gmail.com").exists?
    end

    it "will go to an error page if a user does not enter a password" do

    end

    it "will correctly store password" do

    end
  end

  describe "Tweeting" do

    before(:each)do
      User.delete_all
      User.create(name: "John", user_name: "TestUser2", email:"john@example.com", password: "strongpass")
    end

    it "can save a tweet to the database" do
      Tweet.create(text: "I am toast", author: User.find_by_name("John"), author_name: "John")
      assert (!(Tweet.find_by_text("I am toast") == nil))
    end


    it "can retrieve all tweets by a user" do
    #  tweets = Tweet.find_by_author_id(1)

    end

    it "can isolate tags" do

    end

    it "can isolate mentions" do

    end

  end

end
