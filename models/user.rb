class User <ActiveRecord::Base
  validates_uniqueness_of :handle, :email

  has_many :tweets
  
  def to_json
    super(:except => :password)
  end


end
