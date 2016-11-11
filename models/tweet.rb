require 'byebug'

class Tweet <ActiveRecord::Base
   belongs_to :author, :class_name => "User"
   has_many :home_feeds
   
   has_many :mentions
   has_many :mentioned_users, :class_name =>"User", through: :mentions, :source => :user

  #need to add character limit validation
  validates :text, presence: true #checks that the text is not empty
  validates :author, presence: true

  after_initialize :set_default_values

  def set_default_values
    self.likes ||= 0
    self.reply ||= false
  end

  #Add to_json method that adds in other information not part of the Tweet record itself


  def is_reply?
    self.reply
  end

  def increase_likes
        self.likes += 1
        self.save 
  end

end
