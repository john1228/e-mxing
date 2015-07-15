class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.date :date
      t.string :device
      t.integer :point
      t.integer :number
    end
  end
end
