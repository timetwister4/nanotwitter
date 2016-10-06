class CreateUsers <ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :user_name
      t.string :email
      t.string :password
      t.integer :followers
      t.integer :following
      t.integer :tweet_count
      t.timetstamps :date_joined
    end
  end

  def self.down
    drop_table :users
  end
end
