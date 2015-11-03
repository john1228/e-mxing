class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :tag
      t.string :name
    end
    add_column :skus, :tag, :string
  end
end
