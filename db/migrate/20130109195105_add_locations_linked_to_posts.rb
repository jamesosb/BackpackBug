class AddLocationsLinkedToPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :locations_linked, :boolean
  end
end
