class AddOrderToLocationsPosts < ActiveRecord::Migration
  def change
    change_table :location_posts do |t|
       t.integer :display_order
       t.timestamps
    end
  end
end