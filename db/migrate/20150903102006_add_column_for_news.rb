class AddColumnForNews < ActiveRecord::Migration
  def change
    add_column :news, :tag, :string, default: ''
    add_column :dynamic_images, :tag, :string, array: true, default: []
  end
end
