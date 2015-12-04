class CreateClocks < ActiveRecord::Migration
  def change
    create_table :clocks do |t|
      t.references :coach
      t.timestamps null: false
    end
  end
end
