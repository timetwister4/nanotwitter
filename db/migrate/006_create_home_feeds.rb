class CreateHomeFeeds <ActiveRecord::Migration
  def self.up
    create_table :home_feeds do |t|
        t.belongs_to :user
        t.belongs_to :tweet
    end
  end

  def self.down
    drop_table :home_feeds
  end
end
