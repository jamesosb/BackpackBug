class AddPrimaryKeyToLocationPosts < ActiveRecord::Migration
  def change
    add_column :location_posts, :id, :primary_key
  end
end
