class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :user_id
      t.st_point :lonlat, :geographic => true

      t.timestamps
    end

    add_index :places, :lonlat, using: :gist
  end
end
