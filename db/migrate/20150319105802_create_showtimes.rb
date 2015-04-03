class CreateShowtimes < ActiveRecord::Migration
  def change
    create_table :showtimes do |t|
      t.integer :user_id
      t.string :title
      t.string :cover
      t.string :film
      t.string :intro
      t.timestamps
    end
  end
end
