ActiveAdmin.register Dynamic do
  menu label: '型秀'

  belongs_to :user
  navigation_menu :user

  permit_params :user_id, :content,
                dynamic_images_attributes: [:id, :image],
                dynamic_film_attributes: [:id, :cover, :film]

  filter :content, label: '内容'

  index title: '动态' do
    selectable_column
    column('内容') { |dynamic| dynamic.content }
    column('图片') { |dynamic| image_tag(dynamic.dynamic_images.first.image.thumb.url) unless dynamic.dynamic_images.blank? }
    column('视频') { |dynamic| video_tag(dynamic.dynamic_film.film.url, poster: dynamic.dynamic_film.cover.thumb.url) unless dynamic.dynamic_film.blank? }
    actions
  end

  show title: '动态信息' do
    tabs do
      tab '0-评论' do
        paginated_collection(dynamic.dynamic_comments.page(params[:comment_page]), param_name: :comment_page) do
          table_for(collection, class: 'index_table') do
            column('用户') { |comment|
              div image_tag(comment.user.profile.avatar.thumb.url)
              div style: '' do
                comment.user.profile.name
              end
            }
            column('评论') { |comment| comment.content }
          end
        end
      end
    end
  end

  sidebar '详情 ', only: :show do
    attributes_table_for dynamic do
      row('内容') { dynamic.content }
      row('图片') {
        table do
          tr do
            for dynamic_image in dynamic.dynamic_images
              image_tag(dynamic_image.image.thumb.url)
            end
          end
        end
      } unless dynamic.dynamic_images.blank?
      row('视频') {
        video_tag(dynamic.dynamic_film.film.url, post: dynamic.dynamic_film.cover, controls: true)
      } unless dynamic.dynamic_film.blank?
    end
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs '发表动态' do
      f.input :user_id, as: :hidden
      f.input :top, label: '置顶为视频秀', as: :check_boxes, collection: [['', 1]]
      f.input :content, label: '内容', input_html: {cols: 5, rows: 5}
    end
    f.inputs '图片' do
      f.has_many :dynamic_images, heading: false do |dynamic_image|
        dynamic_image.input :image, label: '图片', as: :file
      end
    end
    f.inputs '视频', for: [:dynamic_film, f.object.dynamic_film||DynamicFilm.new] do |dynamic_film|
      dynamic_film.input :title, label: '标题'
      dynamic_film.input :cover, label: '封面', as: :file
      dynamic_film.input :film, label: '视频', as: :file
    end

    f.actions
  end
end
