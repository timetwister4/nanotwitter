class AddAuthorNameToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :author_name, :string
  end
end
