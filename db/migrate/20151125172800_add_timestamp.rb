class AddTimestamp < ActiveRecord::Migration
  def change
    add_timestamps :categories
    add_timestamps :tags
  end
end
