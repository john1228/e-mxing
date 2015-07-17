ActiveAdmin.register Banner do
  menu label: '广告', parent: '配置'
  permit_params :id, :image, :url, :start_date, :end_date


  index title: '广告列表' do
    selectable_column
    column('图片', :image) { |banner| link_to(image_tag(banner.image.url(:thumb), height: 130), admin_banner_path(banner)) }
    column('链接', :url) { |banner| link_to(banner.url, banner.url) }
    column('起始时间', :start_date) { |banner| banner.start_date }
    column('结束时间', :end_date) { |banner| banner.end_date }
    actions
  end

  show do
    panel '' do
      attributes_table_for banner do
        row '图片' do
          image_tag(banner.image.url(:thumb), height: 65)
        end
        row '链接地址' do
          link_to(banner.url, banner.url)
        end
        row '起始时间' do
          banner.start_date.to_s
        end
        row '结束时间' do
          banner.end_date.to_s
        end
      end
    end
  end

  form html: {enctype: 'multipart/form-data', class: 'form-horizontal'} do |f|
    f.inputs '添加广告' do
      f.input :image, label: '图片', as: :file
      f.input :url, label: '链接地址', as: :url, hint: '请输入图片要链接到目标地址'
      f.input :start_date, label: '起始时间', as: :datepicker
      f.input :end_date, label: '结束时间', as: :datepicker
    end
    f.actions
  end

end
