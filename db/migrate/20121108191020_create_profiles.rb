class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :forename
      t.string :surname
      t.decimal :currentlatitude
      t.decimal :currentlongitude

      t.timestamps
    end
  end
end
