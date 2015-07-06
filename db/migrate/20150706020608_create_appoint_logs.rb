class CreateAppointLogs < ActiveRecord::Migration
  def change
    create_table :appoint_logs do |t|
      t.references :appointment
      t.integer :status
      t.timestamps null: false
    end
    add_index :appoint_logs, [:appointment_id, :status], unique: true
  end
end
