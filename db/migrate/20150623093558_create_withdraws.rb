class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.references :coach
      t.string :name
      t.string :account
      t.decimal :amount
      t.timestamps null: false
    end
  end
end
