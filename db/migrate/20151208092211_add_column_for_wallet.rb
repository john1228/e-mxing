class AddColumnForWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :integral, :integer, default: 0
    add_column :wallet_logs, :source, :string, default: ''
    add_column :wallet_logs, :integral, :integer, default: 0

    add_column :skus, :course_during, :integer
  end
end
