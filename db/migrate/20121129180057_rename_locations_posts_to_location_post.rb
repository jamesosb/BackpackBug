class RenameLocationsPostsToLocationPost < ActiveRecord::Migration
def change
        rename_table :locations_posts, :location_posts
    end 
end
