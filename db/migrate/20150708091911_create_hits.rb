class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.date :date
      t.string :device
      t.string :point
      t.string :number
    end
  end
end
