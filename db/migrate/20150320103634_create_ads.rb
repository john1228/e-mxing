class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :image
      t.string :url
      t.date :from_date
      t.date :end_date
    end
  end
end
