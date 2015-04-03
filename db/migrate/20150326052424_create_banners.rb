class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :image
      t.string :url
      t.date :start_date
      t.date :end_date
    end
  end
end
