class CreateTweets <ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :text
      t.integer :likes
      t.boolean :reply
      t.integer :reply_id
      t.timestamps 
    end
  end

  def self.down
    drop_table :tweets
  end
end