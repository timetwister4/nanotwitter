class CreateTags <ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.text :text
      t.has_many :tweet
    end
  end

  def self.down
    drop_table :tags
  end
end
