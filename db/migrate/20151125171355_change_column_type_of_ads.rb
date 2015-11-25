class ChangeColumnTypeOfAds < ActiveRecord::Migration
  def change
    change_column :banners, :link_id, :string, default: ''
  end
end
