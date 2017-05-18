class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.text :desc
      t.string :plantype
      t.boolean :complete
      t.integer :position

      t.timestamps
    end
  end
end
