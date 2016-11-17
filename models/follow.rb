require_relative "tweet.rb"
require_relative "user.rb"
require_relative '../helpers/follow_validator'

class Follow <ActiveRecord::Base
  #include ActiveModel::Validations
   belongs_to :follower, :class_name => "User"
   belongs_to :followed, :class_name  => "User"

   validates :follower, presence: true
   validates :followed, presence: true
   #validates_with FollowValidator


  #find way to validate uniqueness of pairing


	def get_followed_users_tweets(id)



	end

end
