class CreateMassMessages < ActiveRecord::Migration
  def change
    create_table :mass_messages do |t|
      t.references :service
      t.integer :user_id, array: true, default: []
      t.string :content
      t.timestamps null: false
    end
  end
end
