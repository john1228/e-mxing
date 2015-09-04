ActiveAdmin.register Dynamic do
  menu label: '动态'
  actions :index
  scope('0-所有动态', :all, default: true){|scope| scope.order(id: :desc)} 
  scope('1-带图动态', :image){|scope| scope.joins(:dynamic_images).uniq.order(id: :desc)} 
  index title: '动态' do
     column('发布者头像') do |dynamic|
      dynamic.user.profile.mxid
    end
    column('发布者名称') do |dynamic|
      dynamic.user.profile.name
    end
    column('发布者头像') do |dynamic|
      image_tag(dynamic.user.profile.avatar.thumb.url,height: 50)
    end
    column('发布内容') do |dynamic|
      div do
        image_tag(dynamic.dynamic_images.first.image.thumb.url,width:50)
        p dynamic.content
      end
    end
    column('发布时间') { |dynamic| dynamic.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S') }
    actions do
      link_to('1')
    end
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

  form partial: 'form'
end
