class CreateSetOffs < ActiveRecord::Migration
  def change
    create_table :set_offs do |t|
      t.references :coach
      t.string :start
      t.string :end
      t.boolean :repeat
      t.integer :week, array: true, default: []
    end


    add_column :wallets, :lock_version, :integer, default: 0
    add_column :skus, :lock_version, :integer, default: 0
  end
end
