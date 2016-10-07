class User <ActiveRecord::Base
  #validates_uniqueness_of :handle, :email #allows for uniqueness of handles and emails
  has_many :tweets

  has_many :tweets
  
  def to_json
    super(:except => :password)
  end

  after_initialize :set_default_values

  def set_default_values
    self.followers ||= 0
    self.following ||= 0
    self.tweet_count ||=0
  end

end
