class CreateSetOffs < ActiveRecord::Migration
  def change
    create_table :set_offs do |t|
      t.references :coach
      t.string :start
      t.string :end
      t.boolean :repeat
      t.integer :week, array: true, default: []
    end
  end
end
