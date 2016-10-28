class User <ActiveRecord::Base
  #validates_uniqueness_of :user_name, :email #allows for uniqueness of handles and emails
  validates :user_name, presence: true, uniqueness: { case_sensitive: false}
  validates :email, presence: true, uniqueness: { case_sensitive: false}
  validates :password, presence: true
  validates :name, presence: true

  has_many :tweets, :class_name => "Tweet",
    :foreign_key => :author_id

  has_many :followers, :class_name => "Follow",
    :foreign_key => :follower_id

  has_many :followed_users, :class_name => "Follow",
    :foreign_key => :followed_id
  #has_many :followed_users, :through => :follows
  #has_many :followings, :class_name => "Follow",
  #  :foreign_key => :followed_id

  def to_json
    super(:except => :password)
  end

  after_initialize :set_default_values

  def set_default_values
    self.follower_count ||= 0
    self.following_count ||= 0
    self.tweet_count ||=0
  end

  def increment_followers
    self.follower_count += 1
  end

  def decrement_followers
    self.follower_count -= 1
  end

  def increment_tweets
    self.tweet_count += 1
  end

  def decrement_tweets
    self.tweet_count -= 1
  end

  def increment_following
    self.following +=1
  end

  def decrement_following
    self.following -= 1
  end

#consider adding following functions to the User class?
  #def tweet (text, etc)

  #def follow (user)

  #def unfollow (user)

  #def my_tweets

end
