class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.string :cover
      t.string :url
      t.text :content
      t.integer :cover_width
      t.integer :cover_height

      t.timestamps null: false
    end
  end
end
