class HomeFeed <ActiveRecord::Base
  validates :user, presence: true
  validates :tweet, presence:true
  
  belongs_to :user
  belongs_to :tweet

end
