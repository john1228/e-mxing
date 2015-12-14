class Remove < ActiveRecord::Migration
  def change
    drop_table :set_offs

  end
end
