class User <ActiveRecord::Base
  #validates_uniqueness_of :user_name, :email #allows for uniqueness of handles and emails
  validates :user_name, presence: true, uniqueness: { case_sensitive: false}
  validates :email, presence: true, uniqueness: { case_sensitive: false}
  validates :password, presence: true
  validates :name, presence: true

  has_many :tweets

  has_many :follows

  def to_json
    super(:except => :password)
  end

  after_initialize :set_default_values

  def set_default_values
    self.followers ||= 0
    self.following ||= 0
    self.tweet_count ||=0
  end

  def increment_followers
    self.followers += 1
  end

  def decrement_followers
    self.followers -= 1
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
