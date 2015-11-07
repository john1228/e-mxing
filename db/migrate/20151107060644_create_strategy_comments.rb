class CreateStrategyComments < ActiveRecord::Migration
  def change
    create_table :strategy_comments do |t|
      t.references :strategy
      t.references :user
      t.string :content
      t.timestamps null: false
    end
  end
end
