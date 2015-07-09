class CreateAutoLogins < ActiveRecord::Migration
  def change
    create_table :auto_logins do |t|
      t.references :user
      t.string :device
      t.timestamps null: false
    end
  end
end
