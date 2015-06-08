class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :user
      t.references :track

      t.timestamps null: false
    end
  end
end
