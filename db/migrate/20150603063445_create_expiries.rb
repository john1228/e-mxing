class CreateExpiries < ActiveRecord::Migration
  def change
    create_table :expiries do |t|
      t.references :coach
      t.date :date
      t.timestamps null: false
    end
  end
end
