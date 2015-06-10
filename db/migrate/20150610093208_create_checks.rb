class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :user
      t.timestamps null: false
    end
  end
end
