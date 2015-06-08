class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :coach
      t.string :venues
      t.string :city
      t.string :address
      t.timestamps null: false
    end
  end
end
