class CreateVenueComments < ActiveRecord::Migration
  def change
    create_table :venue_comments do |t|
      t.integer :user_id
      t.integer :venue_id
      t.integer :score
      t.string :content
      t.string :image, array: true, default: []
      t.timestamps null: false
    end
  end
end
