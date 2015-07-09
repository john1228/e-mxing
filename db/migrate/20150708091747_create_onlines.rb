class CreateOnlines < ActiveRecord::Migration
  def change
    create_table :onlines do |t|
      t.date :date
      t.string :device
      t.datetime :open
      t.datetime :close
    end
  end
end
