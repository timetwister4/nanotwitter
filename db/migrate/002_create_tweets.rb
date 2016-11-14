class CreateTweets <ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :text
      t.integer :likes
      t.belongs_to :author
      t.string :author_name
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
