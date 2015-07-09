namespace :st do
  desc '计算应用概况'
  task :overview => :environment do
    report_date = Date.today.yesterday
    activation = Device.where(created_at: report_date...report_date.tomorrow).count
    register = User.where(created_at: report_date...report_date.tomorrow).count
    activity = AutoLogin.select(:device).where(created_at: report_date.yesterday...report_date).uniq.count
    Overview.create(report_date: report_date, activation: activation, register: register, activity: activity)
  end

  desc '设备留存率'
  task :retention => :environment do
    report_date = Date.today.yesterday
    #计算当日设备激活数
    report_date_activations = Device.where(created_at: report_date...report_date.tomorrow).uniq.count
    Retention.create(report_date: report_date, register: report_date_activations)
    #更新次日留存率
    one_day_ago_activations = Device.where(created_at: 1.days.ago(report_date)...report_date).uniq
    one_day_retention_activations = AutoLogin.select(:device).where(created_at: report_date...report_date.tomorrow).uniq
    one_day_retention = Retention.find_or_create_by(report_date: 1.days.ago(report_date))
    one_day_retention.update(day_one: ((one_day_retention_activations/one_day_ago_activations.to_f).round(2) rescue 0))
    #更新3日留存率
    three_day_ago_activations = Device.where(created_at: 3.days.ago(report_date)...2.days.ago(report_date)).uniq
    three_day_retention_activations = AutoLogin.select(:device).where(created_at: 2.days.ago(report_date)...report_date.tomorrow).uniq
    three_day_retention = Retention.find_or_create_by(report_date: 3.days.ago(report_date))
    three_day_retention.update(day_three: ((three_day_retention_activations/three_day_ago_activations.to_f).round(2) rescue 0))
    #更新7日留存率
    seven_day_ago_activations = Device.where(created_at: 1.days.ago(report_date)...report_date).uniq
    seven_day_retention_activations = AutoLogin.select(:device).where(created_at: report_date...report_date.tomorrow).uniq
    seven_day_retention = Retention.find_or_create_by(report_date: 7.days.ago(report_date))
    seven_day_retention.update(day_seven: ((seven_day_retention_activations/seven_day_ago_activations.to_f).round(2) rescue 0))
  end
end