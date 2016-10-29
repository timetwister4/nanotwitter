class Tweet <ActiveRecord::Base
   belongs_to :author, :class_name => "User"
   has_many :feeds

  validates :text, presence: true #checks that the text is not empty
  validates :author, presence: true

  after_initialize :set_default_values

  def set_default_values
    self.likes ||= 0
    self.reply ||= false
  end

  def increment_likes
    self.likes += 1
  end

  def decrement_likes
    self.likes -= 1
  end

  def is_reply?
    self.reply
  end

end
