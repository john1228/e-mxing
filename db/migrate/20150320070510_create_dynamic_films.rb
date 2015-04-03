class CreateDynamicFilms < ActiveRecord::Migration
  def change
    create_table :dynamic_films do |t|
      t.integer :dynamic_id
      t.string :cover
      t.string :film

      t.timestamps
    end
  end
end
