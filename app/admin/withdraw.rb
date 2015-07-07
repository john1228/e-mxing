ActiveAdmin.register Withdraw do
  menu label: '提现申请'
  config.filters = false

  index do
    selectable_column
    column('申请私教') do |withdraw|
      coach = Coach.find_by(id: withdraw.coach_id)
      link_to(coach.profile.name) unless coach.blank?
    end
    column('提现账户', :account)
    column('提现实名', :name)
    column('提现金额', :amount)
    column('提交时间') { |withdraw| withdraw.created_at.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
