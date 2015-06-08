ActiveAdmin.register Group do
  menu label: '群组', priority: 3

  permit_params :id, :name, :hobby, :intro, :owner
  before_filter :adjust, only: [:create, :update]

  controller do
    def adjust
      params[:group][:hobby].reject! { |item| item.blank? }
      params[:group][:hobby] = params[:group][:hobby].join(',')
    end
  end

  filter :name, label: '群名称'
  index do
    selectable_column
    column('群名', :name)
    column('兴趣') { |group| group.interests_string }
    column('介绍', :intro)
    actions
  end

  show do
    panel '群成员' do

    end
  end

  sidebar '群信息', only: :show do
    attributes_table_for group do
      row('群名') { group.name }
      row('兴趣') { group.interests }
      row('介绍') { group.intro }
      row('群主美型号') { group.owner}
    end
  end

  form partial: 'form'
end
