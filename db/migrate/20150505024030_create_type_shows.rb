class CreateTypeShows < ActiveRecord::Migration
  def change
    create_table :type_shows do |t|
      t.string :title
      t.string :cover
      t.string :url
      t.text :content
      t.timestamps null: false
    end
  end
end
