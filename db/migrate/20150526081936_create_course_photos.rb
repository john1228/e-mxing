class CreateCoursePhotos < ActiveRecord::Migration
  def change
    create_table :course_photos do |t|
      t.references :course
      t.string :photo #课程图片
      t.timestamps null: false
    end
  end
end
