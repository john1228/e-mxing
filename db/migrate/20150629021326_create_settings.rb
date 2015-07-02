class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :user
      t.integer :stealth #隐身设置
    end
  end
end
