class AddNotesToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :notes, :text
  end
end
