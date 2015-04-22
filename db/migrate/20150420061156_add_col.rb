class AddCol < ActiveRecord::Migration
  def change
    add_column :news, :cover_width, :integer
    add_column :news, :cover_height, :integer
    remove_column :users, :token
    remove_column :news, :url
    remove_column :activities, :url
    remove_column :activities, :time
    add_column :activities, :start_date, :date
    add_column :activities, :end_date, :date
    add_column :activities, :activity_type, :integer
    add_column :activities, :theme, :integer
  end
end
