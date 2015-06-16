class Change < ActiveRecord::Migration
  def change
    remove_column :courses, :address
    add_column :courses, :address, :integer, array: true, default: []
  end
end
