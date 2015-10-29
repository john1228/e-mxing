ActiveAdmin.register CoachDynamic do
  menu label: '动态'
  belongs_to :coach
  navigation_menu :coach
  permit_params :top, :content,
                dynamic_image: [:id, :image],
                dynamic_film_attributes: [:id, :title, :cover, :film]

  filter :content, label: '内容'

  index title: '动态' do
    selectable_column
    column('内容') { |dynamic| truncate(dynamic.content) }
    column('图片') { |dynamic| image_tag(dynamic.dynamic_images.first.image.url, height: 70) unless dynamic.dynamic_images.blank? }
    column('视频') { |dynamic| video_tag(dynamic.dynamic_film.film.url, poster: dynamic.dynamic_film.cover.url, controls: true, height: 70) unless dynamic.dynamic_film.blank? }
    actions
  end

  show title: '动态信息' do
    attributes_table do
      row('内容') { service_dynamic.content }
      row('图片') {
        table do
          tr do
            for dynamic_image in service_dynamic.dynamic_images
              image_tag(dynamic_image.image.url)
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

  form partial: 'form'

end
