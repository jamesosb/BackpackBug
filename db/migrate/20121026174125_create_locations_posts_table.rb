class CreateLocationsPostsTable < ActiveRecord::Migration
  def self.up
    create_table :locations_posts, :id => false do |t|
        t.references :post
        t.references :location
    end
    add_index :locations_posts, [:location_id, :post_id]
    add_index :locations_posts, [:post_id, :location_id]
  end

  def down
  end
end
