require 'byebug'

class Tweet <ActiveRecord::Base
   belongs_to :author, :class_name => "User"

  validates :text, presence: true, length: { minimum:1, maximum: 140 }
  validates :author, presence: true
  validates :author_name, presence: true

  after_initialize :set_default_values

  def set_default_values
    self.likes ||= 0
  end

  def increment_likes
    self.likes += 1
    self.save
    return self.likes
  end

  def decrement_likes
    if self.likes > 0
      self.likes -= 1
      self.save
      return self.likes
    end
  end
  
end
