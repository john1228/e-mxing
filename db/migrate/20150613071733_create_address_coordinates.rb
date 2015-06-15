class CreateAddressCoordinates < ActiveRecord::Migration
  def change
    rename_column :orders,:bea,:bean
    create_table :address_coordinates do |t|
      t.references :address
      t.st_point :lonlat, :geographic => true
    end
    add_index :address_coordinates, :lonlat, using: :gist
  end
end
