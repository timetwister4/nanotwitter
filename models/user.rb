class User <ActiveRecord::Base
  validates_uniqueness_of :user_name, :email #allows for uniqueness of handles and emails
  validates :user_name, presence: true, uniqueness: { case_sensitive: false}
  validates :email, presence: true, uniqueness: { case_sensitive: false}
  validates :password, presence: true
  validates :name, presence: true

  has_many :tweets , :class_name => "Tweet",  :foreign_key => :author_id
  has_many :home_feeds
  
  # has_one :home_feed, :class_name => "HomeFeed", :foreign_key => :user_id
  # has_one :profile_feed, :class_name => "ProfileFeed", :foreign_key => :user_id

 

  has_many :followers, :class_name => "Follow",
   :foreign_key => :follower_id

  has_many :followed_users, :class_name => "Follow",
    :foreign_key => :followed_id
 
 has_many :mentioned_in, :class_name => "Tweet", through: :mentions,
    :source => :tweet
  

  has_many :mentions

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
    if(follower_count > 0)
      self.follower_count -= 1
    end
  end

  def increment_tweets
    self.tweet_count += 1
  end

  def decrement_tweets
    if(tweet_count > 0)
      self.tweet_count -= 1
    end
  end

  def increment_following
    self.following_count +=1
  end

  def decrement_following
    if (following_count > 0)
      self.following_count -= 1
    end
  end

#consider adding following functions to the User class?
  #def tweet (text, etc)

  #def follow (user)

  #def unfollow (user)

  #def my_tweets

end
