ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: '首页'

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container' do
      span class: 'blank_slate' do
        h3 '欢迎来到美型管理平台'
      end
    end
  end
end
