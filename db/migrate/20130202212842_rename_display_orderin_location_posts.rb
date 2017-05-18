class RenameDisplayOrderinLocationPosts < ActiveRecord::Migration
  def change
    rename_column :location_posts, :display_order, :position
  end
end
