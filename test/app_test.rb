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

   
 end

  describe "Tweeting" do

        before(:each)do
          User.delete_all
          @john = User.create(name: "John", user_name: "TestUser2", email:"john@example.com", password: "strongpass")
        end

        it "can save a tweet to the database" do
          Tweet.create(text: "I am toast", author: User.find_by_name("John"), author_name: "John")
          assert (!(Tweet.find_by_text("I am toast") == nil))
        end


         it "retrieves all tweets by a user" do
          Tweet.create(text: "I am toast", author: User.find_by_name("John"), author_name: "John")
          Tweet.create(text: "I am salad", author: User.find_by_name("John"), author_name: "John")
          Tweet.create(text: "I am sparrow", author: User.find_by_name("John"), author_name: "John")
          tweets = User.find_by_name("John").tweets 
          assert_equal tweets.length , 3 
      
        end

        it "will not create a tweet that has no text" do
          Tweet.create(text: "", author: @john, author_name: "John")
          assert !Tweet.where(text: "").exists?
        end

        it "will not create a tweet that has no author_name" do
          Tweet.create(text: "hey", author: @john )
          assert !Tweet.where(text: "hey").exists?
        end

        it "will not create a tweet that has no author" do
          Tweet.create(text: "hey",  author_name: "John")
          assert !Tweet.where(text: "hey").exists?
        end


   end

   describe "Following" do

      before(:each)do
        User.delete_all
        @john = User.create(name: "John", user_name: "TestUser2", email:"john@example.com", password: "strongpass")
        post '/login/submit', {:email => "john@example.com", :password => "strongpass"}
        @peter = User.create(name: "Peter", user_name: "TestUser3", email:"peter@example.com", password: "strongpass")
      end

      it "can save a follow to the database" do
        Follow.create(follower: @john, followed: @peter)
        assert Follow.where(follower: @john).exists?
      end

      it "following action redirects correctly" do
          post '/user/follow' , {:user_name => "TestUser3"}
          last_response.status == 302
      end

      it "unfollowing action redirects correctly" do
          post '/user/unfollow' , {:user_name => "TestUser3"}
          last_response.status == 302
      end

      it "shows the followers of a User correct" do
          Follow.create(follower: @john, followed: @peter)
          assert_equal @peter.followers[0].follower_id , @john.id
      end

      it "shows the followers of a User correct" do
          Follow.create(follower: @john, followed: @peter)
          assert_equal @john.followed_users[0].followed_id , @peter.id
      end

   

   end


   describe "liking and repliying" do

      before(:each)do
        User.delete_all
        Tweet.delete_all
        @tris = User.create(name: "Tristan", user_name: "Tristan", email:"tris@example.com", password: "strongpass")
        @tweet = Tweet.create(text: "1st tweet", author: @tris , author_name: "Tristan")
        post '/login/submit',
        {:email => "tris@example.com",
            :password => "strongpass"}
      end

      it "likes a tweet with 0 likes correctly " do
             post '/tweet/like', {:tweet_id => @tweet.id}
             assert_equal "1" , last_response.body
      end


     it "A tweet cannot be liked by the same user more than once" do
           post '/tweet/like', {:tweet_id => @tweet.id}
           post '/tweet/like', {:tweet_id => @tweet.id}
           assert_equal "a1".to_json , last_response.body
     end

     it "A tweet liked by two different user receives two likes" do
           post '/tweet/like', {:tweet_id => @tweet.id}
           User.create(name: "Mike", user_name: "Mike", email:"mike@example.com", password: "strongpass")
           post '/login/submit',
           {:email => "mike@example.com",
            :password => "strongpass"}
           post '/tweet/like', {:tweet_id => @tweet.id}
           assert_equal "2" , last_response.body
     end


     it "processes and stores a reply succesfully" do
        post "/tweet/reply/#{@tweet.id}" , {:tweet_text => "response"}
        assert_equal last_response.status, 302
        get '/tweet/replies', {:tweet_id => @tweet.id}
        assert_equal JSON.parse(last_response.body)[0][1], "response"
     end

  end


end
