ActiveAdmin.register ServiceDynamic do
  menu label: '动态'
  belongs_to :service
  navigation_menu :service
  permit_params :top, :content,
                dynamic_images_attributes: [:id, :image],
                dynamic_film_attributes: [:id, :title, :cover, :film]

  filter :content, label: '内容'

  index title: '动态' do
    selectable_column
    column('内容') { |dynamic| dynamic.content }
    column('图片') { |dynamic| image_tag(dynamic.dynamic_images.first.image.thumb.url) unless dynamic.dynamic_images.blank? }
    column('视频') { |dynamic| video_tag(dynamic.dynamic_film.film.url, poster: dynamic.dynamic_film.cover.thumb.url) unless dynamic.dynamic_film.blank? }
    actions
  end

  show title: '动态信息' do
    attributes_table do
      row('内容') { service_dynamic.content }
      row('图片') {
        table do
          tr do
            for dynamic_image in service_dynamic.dynamic_images
              image_tag(dynamic_image.image.thumb.url)
            end
          end
        end
      } unless service_dynamic.dynamic_images.blank?
      row('视频') {
        video_tag(service_dynamic.dynamic_film.film.url, post: service_dynamic.dynamic_film.cover, controls: true)
      } unless service_dynamic.dynamic_film.blank?
    end
  end

  sidebar '评论 ', only: :show do
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    tabs do
      tab '0-文本' do
        f.inputs '发表动态' do
          f.input :top, label: '置顶为视频秀', as: :check_boxes, collection: [['', 1]]
          f.input :content, label: '内容', input_html: {cols: 5, rows: 5}
        end
      end
      tab '1-图片' do
        f.inputs '图片' do
          f.has_many :dynamic_images, heading: false do |dynamic_image|
            dynamic_image.input :image, label: '照片', as: :file
          end
        end
      end
      tab '2-视频' do
        f.inputs '视频', for: [:dynamic_film, f.object.dynamic_film||DynamicFilm.new] do |dynamic_film|
          dynamic_film.input :title, label: '标题'
          dynamic_film.input :cover, label: '封面', as: :file
          dynamic_film.input :film, label: '视频', as: :file
        end
      end
    end
    f.actions
  end


end
