class AddColumnForNews < ActiveRecord::Migration
  def change
    add_column :news, :tag, :string, default: ''
  end
end
