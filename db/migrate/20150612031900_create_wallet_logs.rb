class CreateWalletLogs < ActiveRecord::Migration
  def change
    #add_column :appointments, :lesson_id, :integer
    #add_column :appointments, :status, :integer
    create_table :wallet_logs do |t|
      t.references :wallet
      t.integer :action #动作
      t.integer :balance
      t.string :coupons
      t.integer :bean
      t.timestamps null: false
    end
  end
end
