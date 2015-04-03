class CreateGroupPlaces < ActiveRecord::Migration
  def change
    create_table :group_places do |t|
      t.integer :group_id
      t.st_point :lonlat, :geographic => true

      t.timestamps
    end

    add_index :group_places, :lonlat, using: :gist
  end
end
