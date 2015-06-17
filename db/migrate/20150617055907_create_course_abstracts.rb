class CreateCourseAbstracts < ActiveRecord::Migration
  def change
    create_table :course_abstracts do |t|
      t.references :course
      t.references :address
      t.references :coach
      t.integer :coach_gender
      t.integer :course_price
      t.integer :course_type
      t.st_point :coordinate, :geographic => true
    end

    add_index :course_abstracts, :coordinate, using: :gist
  end
end
