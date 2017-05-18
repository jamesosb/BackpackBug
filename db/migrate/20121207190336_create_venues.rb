class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.text :desc
      t.references :location

      t.timestamps
    end
    add_index :venues, :location_id
  end
end
