class ChangeAppointment < ActiveRecord::Migration
  def change
    # drop_table :appointments
    create_table :appointments do |t|
      t.references :coach
      t.references :user
      t.references :course
      t.integer :amount
      t.integer :status, defaulut: 0
      t.timestamps null: false
    end
  end
end
