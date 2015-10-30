class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :tag
      t.string :name
      t.string :background
    end
    add_column :skus, :tag, :string
  end
end
