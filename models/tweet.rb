require 'byebug'

class Tweet <ActiveRecord::Base
   belongs_to :author, :class_name => "User"
     
  #need to add character limit validation
  validates :text, presence: true #checks that the text is not empty
  validates :author, presence: true

  after_initialize :set_default_values

  def set_default_values
    self.likes ||= 0
  end

  #Add to_json method that adds in other information not part of the Tweet record itself

  def increment_likes
    self.likes += 1
  end

  def decrement_likes
    if self.likes >0
      self.likes -= 1
    end
  end

  def is_reply?
    self.reply
  end

end
