class AddAuthorNameToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :author_name, :string
  end
end
