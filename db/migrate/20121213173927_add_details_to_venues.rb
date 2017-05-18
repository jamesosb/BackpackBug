class AddDetailsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :foursquare_id, :integer
    add_column :venues, :category, :string
  end
end
