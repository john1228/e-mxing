class CreateConcerneds < ActiveRecord::Migration
  def change
    create_table :concerneds do |t|
      t.references :course
      t.references :user
      t.timestamps null: false
    end
  end
end
