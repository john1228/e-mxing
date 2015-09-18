namespace :promotion do
  task :qumi do
    now = Time.now
    regist_devices = User.where(created_at: now.ago(6*3600)..now).pluck(:device)
    Promotion.where(channel: 'qumi', device: regist_devices.sample(regist_devices.size*0.8), sync: false).map { |promotion|
      Faraday.get promotion.callback_url
      promotion.update(sync: true)
    }
  end
end