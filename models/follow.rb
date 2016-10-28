class Follow <ActiveRecord::Base
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name  => "User"

  #find way to validate uniqueness of pairing

end
