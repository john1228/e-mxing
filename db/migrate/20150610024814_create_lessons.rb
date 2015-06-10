class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :order
      t.references :coach
      t.references :user
      t.references :course
      t.integer :available #可用课时
      t.integer :used #已用课时
      t.date :exp
    end
  end
end
