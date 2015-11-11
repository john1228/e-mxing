ActiveAdmin.register CrawlDatum do
  menu label: '抓取数据'
  config.filters = false
  permit_params :name, :avatar, :address, :business, service_change: [], photo_change: []
  actions :index, :show, :edit, :update, :destroy

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
    actions
  end


  batch_action :apply do |ids|
    CrawlDatum.find(ids).each { |crawl_data|
      service = Service.new(mobile: SecureRandom.uuid, sns: SecureRandom.uuid, profile_attributes: {
                                               name: crawl_data.name,
                                               avatar: crawl_data.url,
                                               province: crawl_data.province,
                                               city: crawl_data.city,
                                               area: crawl_data.area,
                                               address: crawl_data.address,
                                               signature: crawl_data.intro,
                                               service: crawl_data.service_change,
                                               mobile: crawl_data.tel,
                                               business: crawl_data.business,
                                           })
      service.reload
      service.photos.create(crawl_data.photo.map{|photo|})
    }
  end

  form partial: 'form'
end
