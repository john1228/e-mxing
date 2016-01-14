ActiveAdmin.register Withdraw do
  menu label: '提现申请'

  filter :name, label: '名字'
  filter :account, label: '账户'
  actions :index
  scope('0-全部', :all, default: true)
  scope('1-提现请求', :requests) { |scope| scope.where(status: Withdraw::STATUS['提现请求']) }
  scope('2-处理中', :processing) { |scope| scope.where(status: Withdraw::STATUS['已处理']) }
  scope('3-处理完成', :success) { |scope| scope.where(status: Withdraw::STATUS['成功']) }
  scope('4-处理失败', :failure) { |scope| scope.where(status: Withdraw::STATUS['失败']) }
  index do
    selectable_column
    column('申请人') do |withdraw|
      people = User.find_by(id: withdraw.coach_id)
      link_to(people.profile.name, withdraw_people_path(people), class: 'fancybox', data: {'fancybox-type' => 'ajax'})
    end
    column('提现账户', :account)
    column('提现实名', :name)
    column('提现金额', :amount)
    column('提交时间') { |withdraw| withdraw.created_at.strftime('%Y-%m-%d %H:%M:%S') }
  end
  batch_action '处理', if: proc { current_admin_user.super? } do |ids|
    Withdraw.where(id: ids).update_all(status: Withdraw::STATUS['已处理'])
    redirect_to collection_path, alert: '处理成功'
  end

  batch_action '成功', if: proc { current_admin_user.super? } do |ids|
    Withdraw.where(id: ids).update_all(status: Withdraw::STATUS['成功'])
    redirect_to collection_path, alert: '处理成功'
  end


  batch_action '失败', if: proc { current_admin_user.super? } do |ids|
    Withdraw.where(id: ids).each { |withdraw| withdraw.update(status: Withdraw::STATUS['失败']) }
    redirect_to collection_path, alert: '处理成功'
  end

  controller do
    def people
      @user = User.find_by(id: params[:id])
      render layout: false
    end
  end
end
