ActiveAdmin.register CrawlDatum do
  menu label: '抓取数据'
  config.filters = false

  index do
    selectable_column
    column '名称', :name
    column '头像' do |crawl_datum|
      image_tag(crawl_datum.avatar)
    end
    column '地址', :address
    column '营业时间', :business
    column '联系电话', :tel
    column '提供服务' do |crawl_datum|
      crawl_datum.service.join('|')
    end
    column '照片' do |crawl_datum|
      render partial: 'photo', locals: {photo: crawl_datum.photo}
    end
    column '介绍' do |crawl_datum|
      crawl_datum.intro
    end
  end
end
