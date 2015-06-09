class CreateAppointmentSettings < ActiveRecord::Migration
  def change
    create_table :appointment_settings do |t|
      #团操和1v1共有属性
      t.references :coach
      t.date :start_date
      t.string :time#开始结束时间,eg: 开始时间|结束时间,开始时间|结束时间
      t.references :address
      #1v1特有属性
      t.boolean :repeat
      #团操特有属性
      t.string :course_name
      t.string :course_type
      t.integer :place
      t.timestamps null: false
    end
  end
end
