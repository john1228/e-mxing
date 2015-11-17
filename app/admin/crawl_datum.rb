ActiveAdmin.register CrawlDatum do
  menu label: '抓取数据'
  config.filters = false
  permit_params :name, :avatar, :address, :business, service_replace: [], photo_replace: []
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
      render partial: 'photo', locals: {photo: crawl_datum.photo||[]}
    end
    column '介绍' do |crawl_datum|
      crawl_datum.intro
    end
    actions
  end


  show do
    attributes_table do
      row :name
      row :avatar do
        image_tag(crawl_datum.avatar)
      end
      row :province
      row :city
      row :area
      row :address
      row :business
      row :service_replace do
        INTERESTS['items'].map { |item| item['name'] if crawl_datum.service_replace.include?(item['id']) }.compact!.join(',')
      end
      row :intro
      row :photo_replace do
        render partial: 'photo', locals: {photo: crawl_datum.photo_replace.blank? ? crawl_datum.photo||[] : crawl_datum.photo_replace.map { |item| item.url }}
      end
    end
  end

  batch_action :apply do |ids|
    message = '加入成功'
    CrawlDatum.find(ids).each { |crawl_datum|
      profile = Profile.service.new(
          name: crawl_datum.name,
          remote_avatar_url: crawl_datum.avatar,
          province: crawl_datum.province,
          city: crawl_datum.city,
          area: crawl_datum.area,
          address: crawl_datum.address,
          signature: crawl_datum.intro||'暂无介绍',
          hobby: crawl_datum.service_replace,
          mobile: crawl_datum.tel,
          business: crawl_datum.business
      )
      service = profile.build_user(mobile: SecureRandom.uuid, sns: SecureRandom.uuid)
      service.photos.new((crawl_datum.photo||[]).map { |photo| {remote_photo_url: photo} })
      unless profile.save
        message = profile.errors.messages.values.join(',')
      end
    }
    redirect_to collection_path, alert: message
  end

  form partial: 'form'
end
