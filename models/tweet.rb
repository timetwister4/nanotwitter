class Tweet <ActiveRecord::Base
  belongs_to :author, class_name: "User"

  after_initialize :set_default_values

  def set_default_values
    self.likes ||= 0
    self.reply ||= false
  end

end