class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :system
      t.string :device
      t.string :channel
      t.string :version
      t.string :ip
      t.string :token
      t.timestamps null: false
    end
  end
end
