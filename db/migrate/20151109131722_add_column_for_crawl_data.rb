class AddColumnForCrawlData < ActiveRecord::Migration
  def change
    add_column :crawl_data, :intro, :text, default: ''
  end
end
