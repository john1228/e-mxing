class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :user_id
      t.integer :track_type
      t.integer :coach_id
      t.string :name
      t.string :intro
      t.string :address
      t.integer :places
      t.integer :free_places
      t.date :start
      t.integer :during

      t.timestamps
    end
  end
end
