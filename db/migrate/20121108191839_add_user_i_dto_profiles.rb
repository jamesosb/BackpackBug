class AddUserIDtoProfiles < ActiveRecord::Migration
  def up
    change_table :profiles do |t|
      t.references :user
    end
  end

  def down
  end
end
