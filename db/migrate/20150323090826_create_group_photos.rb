class CreateGroupPhotos < ActiveRecord::Migration
  def change
    create_table :group_photos do |t|
      t.integer :group_id
      t.string :photo

      t.timestamps null: false
    end
  end
end
