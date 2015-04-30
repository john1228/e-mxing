ActiveAdmin.register Group do
  menu label: '群组', priority: 3

  permit_params :id, :name, :interests, :intro

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
    end
  end

  form partial: 'form'
end
