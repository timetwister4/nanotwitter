require_relative './test_helper.rb'
require 'byebug'

require_relative '../app.rb'
require_relative '../models/user.rb'

include Rack::Test::Methods

describe "App" do
  describe "Authentication" do

    def app
      Sinatra::Application
    end

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
    assert last_response.ok?

    assert last_response.body.include?("Bjorn")
  end

    it "can log a user out" do

    end

    it "serves correct page if logged in" do

    end

    it "serves correct page if logged out" do

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

end
