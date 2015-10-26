class CreateCrawlData < ActiveRecord::Migration
  def change
    create_table :crawl_data do |t|
      t.string :name
      t.string :avatar
      t.string :address
      t.string :tel
      t.string :business
      t.string :service, array: true
      t.string :photo, array: true
      t.timestamps null: false
    end
  end
end
