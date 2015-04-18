ActiveAdmin.register_page "Dashboard" do
  menu false
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        paginated_collection(User.order(id: :desc).page(params[:user_page]), param_name: :user_page) do
          table_for(collection, class: 'index_table') do
            column('美型号') { |user| user.profile.mxid }
            column('昵称') { |user| user.profile.name }
            column('头像') { |user| image_tag(user.profile.avatar.thumb.url, height: 70) }
            column('性别') { |user| user.profile.gender.eql?(1) ? '女' : '男' }
            column('签名') { |user| truncate(user.profile.signature) }
          end
        end
      end
    end
  end
end
