class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.references :coach
      t.string :account
      t.string :name
      t.string :amount
      t.timestamps null: false
    end
  end
end
