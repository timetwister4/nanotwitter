require_relative './test_helper.rb'
require 'byebug'

set :environment, :test

describe "nanotwitter" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "POST user information" do
    it "can log a user in" do
      puts "Creating user"
      User.create(
        name: "Bjorn",
        user_name: "thunderbear",
        email: "teamthunderbeardev@gmail.com",
        password: "strongpass"
        )
        puts "loggin user in"
        byebug
        post '/login/submit', {email: "teamthunderbeardev@gmail.com",
          password: "strongpass"}.to_json
        puts " checking response"
        response = JSON.parse(last_response.body)
        puts response
      end
  end


end
