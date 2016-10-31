require_relative "tweet.rb"
require_relative "user.rb"

class Follow <ActiveRecord::Base
   belongs_to :follower, :class_name => "User"
   belongs_to :followed, :class_name  => "User"

  #find way to validate uniqueness of pairing


	def get_followed_users_tweets(id)



	end

end
