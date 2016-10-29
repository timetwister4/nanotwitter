class CreateFeeds <ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :user_id
      t.boolean :profile_feed
      t.boolean :home_feed 
      t.integer :tweet_id
    end
  end

  def self.down
    drop_table :feeds
  end
end
