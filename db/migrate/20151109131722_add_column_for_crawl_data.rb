class AddColumnForCrawlData < ActiveRecord::Migration
  def change
    add_column :crawl_data, :intro, :text, default: ''

    add_column :crawl_data, :province, :string, default: :''
    add_column :crawl_data, :city, :string, default: ''
    add_column :crawl_data, :area, :string, default: ''
    
    add_column :crawl_data, :service_replace, :integer, array: true, default: []
    add_column :crawl_data, :photo_replace, :string, array: true, default: []
  end
end
