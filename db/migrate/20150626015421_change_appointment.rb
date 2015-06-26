class ChangeAppointment < ActiveRecord::Migration
  def change
    create_table :appointments, force: true do |t|
      t.references :coach
      t.references :user
      t.references :course
      t.references :lesson
      t.integer :amount
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
