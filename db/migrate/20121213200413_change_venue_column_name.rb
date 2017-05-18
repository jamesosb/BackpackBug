class ChangeVenueColumnName < ActiveRecord::Migration
  def change
    change_column :venues, :foursquare_id, :string
  end

end
