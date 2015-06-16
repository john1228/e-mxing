class CreateCourseAddresses < ActiveRecord::Migration
  def change
    create_table :course_addresses do |t|
      t.references :course
      t.references :address
      t.timestamps null: false
    end
  end
end
