class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :user_id
      t.integer :track_type
      t.date :start
      t.integer :during

      t.timestamps
    end
  end
end
