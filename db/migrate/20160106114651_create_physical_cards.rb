class CreatePhysicalCards < ActiveRecord::Migration
  def change
    create_table :physical_cards do |t|
      t.integer :service_id
      t.string :virtual_number
      t.string :entity_number
    end
  end
end
