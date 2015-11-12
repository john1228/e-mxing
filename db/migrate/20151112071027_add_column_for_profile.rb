class AddColumnForProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :area, :string
    add_column :profiles, :business, :string
  end
end
