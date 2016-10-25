class Tweet <ActiveRecord::Base
  belongs_to :author, class_name: "User"

  validates :text, presence: true #checks that the text is not empty
  after_initialize :set_default_values

  def set_default_values
    self.likes ||= 0
    self.reply ||= false
  end

end
