class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :user
      t.date :date, default: Date.today
    end
  end
end
