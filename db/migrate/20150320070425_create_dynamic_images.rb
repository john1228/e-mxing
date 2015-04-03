class CreateDynamicImages < ActiveRecord::Migration
  def change
    create_table :dynamic_images do |t|
      t.integer :dynamic_id
      t.string :image
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end
end
