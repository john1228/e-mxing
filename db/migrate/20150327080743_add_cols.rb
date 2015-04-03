class AddCols < ActiveRecord::Migration
  def change
    change_column :tracks, :start, :datetime
    change_column :tracks, :during, :string
  end
end
