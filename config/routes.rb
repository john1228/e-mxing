Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :reports

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #验证码
  post 'captcha/regist' => 'captcha#regist'
  post 'captcha/change' => 'captcha#change'
  post 'captcha/binding' => 'captcha#binding'
  post 'captcha/check' => 'captcha#check'
  #用户登录和注册
  post 'users/login' => 'users#login'
  post 'users/sns' => 'users#sns'
  put 'users' => 'users#update'
  delete 'users' => 'users#logout'
  #个人资料
  get 'profile' => 'profile#index'
  put 'profile' => 'profile#complete'
  post 'profile' => 'profile#update'
  #运动轨迹
  get 'tracks' => 'tracks#index'
  get 'tracks/show' => 'tracks#show'
  post 'tracks' => 'tracks#create'
  post 'tracks/appoint' => 'tracks#appoint'
  put 'tracks' => 'tracks#update'
  delete 'tracks/:id' => 'tracks#destroy'
  #视频秀
  get 'showtime' => 'showtime#index'
  post 'showtime' => 'showtime#update'
  #照片墙
  get 'photos' => 'photos#index'
  post 'photos' => 'photos#create'
  put 'photos' => 'photos#update'
  delete 'photos/:loc' => 'photos#destroy'
  #动态
  get 'dynamics' => 'dynamics#index'
  get 'dynamics/latest' => 'dynamics#latest'
  post 'dynamics' => 'dynamics#create'
  delete 'dynamics/:id' => 'dynamics#destroy'
  #赞
  post 'likes/:type' => 'like#create'
  get 'likes' => 'like#count'
  #评论
  get 'comments' => 'comments#show'
  post 'comments' => 'comments#create'
  #发现
  get 'find' => 'find#list'
  put 'find/upload' => 'find#upload'
  get 'find/tips' => 'find#tips'
  #群组
  get 'groups/mine' => 'groups#mine'
  get 'groups' => 'groups#show'
  post 'groups' => 'groups#create'
  put 'groups' => 'groups#update'
  delete 'groups/:id' => 'groups#destroy'
  #群組相冊
  get 'group_photos' => 'group_photos#index'
  post 'group_photos' => 'group_photos#create'
  delete 'group_photos/:group_id/:id' => 'group_photos#destroy'
  #获取用户信息
  get 'friends' => 'friends#index'
  post 'friends' => 'friends#create'
  get 'friends/search' => 'friends#find'
  #服务号
  get 'services/coaches' => 'services#coaches'
  #陪组文件
  get 'deploy/icon' => 'deploy#icon'
  get 'deploy/banner' => 'deploy#banner'
  get 'deploy/json' => 'deploy#json'
  #系统接口
  post 'feedback' => 'system#feedback'
  post 'report' => 'system#report'
  #web路由
  get 'home/index' => 'home#index'
  get 'home/about' => 'home#about'
  get 'home/dynamic' => 'home#dynamic'
  get 'home/contact' => 'home#contact'
  get 'home/join' => 'home#join'
  get 'wap' => 'wap#index'
  get 'wap/film' => 'wap#film'
  get 'wap/course' => 'wap#course'

  get 'news/:id' => 'news#show', as: :news_detail
  get 'type_shows/:id' => 'type_shows#show', as: :type_show_detail
  get 'activities/:id' => 'activities#show', as: :activity_detail
  put 'activities/:id' => 'activities#apply', as: :apply_activity
  post 'activities/:id' => 'activities#group', as: :join_in_group_of_activity
  get 'activities' => 'activities#mine'
  get '/admin/services/:id/chat' => 'admin/services#chat', as: :chat_with_service

  get '/admin/enthusiasts/:id/transfer' => 'admin/enthusiasts#transfer', as: :pre_transfer
  post '/admin/enthusiasts/:id/transfer' => 'admin/enthusiasts#transfer_result', as: :summit_transfer, defaults: {format: 'js'}

  get 'download' => 'download#index'

  get 'orders/pay' => 'orders#pay'

  get 'webchat' => 'webchat#index'

  get 'share/:id/dynamic' => 'share#dynamic'
  get 'share/service' => 'share#service'

  root 'home#index'

  get 'appointments' => 'appointments#index'
  get 'appointments/day' => 'appointments#day'


  namespace :business do
    #登录
    post 'login' => 'login#mobile'
    #设置
    post 'settings' => 'appointment_settings#create'
    #地址管理
    get 'addresses' => 'addresses#index'
    post 'addresses' => 'addresses#create'
    #课程
    get 'courses' => 'courses#index'
    get 'courses/:type' => 'courses#index'
    post 'courses' => 'courses#create'
    put 'courses' => 'courses#update'
    delete 'courses/:id' => 'courses#destroy'
    #设置
    post 'settings/one' => 'appointment_settings#one_to_one'
    post 'settings/many' => 'appointment_settings#one_to_many'
    #预约
    get 'appointments' => 'appointments#index'
    get 'appointments/show' => 'appointments#show'
    post 'appointments' => 'appointments#create'
    put 'appointments' => 'appointments#cancel'
    post 'appointments/to_rest' => 'appointments#rest'
    post 'appointments/to_class' => 'appointments#cancel_rest'

    #订单
    get 'orders' => 'orders#index'
    get 'orders/show' => 'orders#show'
    #钱包
    get 'wallet' => 'wallet#index'
    get 'wallet/coupons' => 'wallet#coupons'
    get 'wallet/detail' => 'wallet#detail'
    #学员
    get 'students' => 'students#index'
    get 'students/course' => 'students#course'
  end

  namespace :gyms do
    #查看课程和购买
    get 'courses' => 'courses#index'
    get 'courses/show' => 'courses#show'
    get 'courses/coach' => 'courses#coach'
    get 'courses/comments' => 'courses#comments'
    post 'courses' => 'courses#buy'
    post 'courses/concern' => 'courses#concern'
    get 'courses/concerned' => 'courses#concerned'
    #查看预约和预约团课
    get 'appointments' => 'appointments#index'
    get 'appointments/show' => 'appointments#show'
    post 'appointments' => 'appointments#appoint'
    post 'appointments/comment' => 'appointments#comment'
  end

  namespace :mine do
    #关注
    get 'concerns' => 'concerns#index'
    post 'concerns' => 'concerns#create'
    delete 'concerns/:course' => 'concerns#destroy'
    #订单
    get 'orders' => 'orders#index'
    get 'orders/unprocessed' => 'orders#unprocessed'
    get 'orders/show' => 'orders#show'
    post 'orders' => 'orders#create'
    delete 'orders/:no/cancel' => 'orders#cancel'
    delete 'orders/:no/delete' => 'orders#delete'
    #课时
    get 'lessons' => 'lessons#index'
    put 'lessons' => 'lessons#confirm'
    post 'lessons/comment' => 'lessons#comment'
    #钱包
    get 'wallet' => 'wallet#index'
    get 'wallet/coupons' => 'wallet#coupons'
    get 'wallet/detail' => 'wallet#detail'
    put 'wallet' => 'wallet#update'
  end

  namespace :callback do
    post 'alipay' => 'alipay#callback'
    get 'jd' => 'jd#callback'
    get 'webchat' => 'webchat#callback'
  end
  #B端网页版
  namespace :hb do
    get 'login' => 'login#new'
    post 'login' => 'login#mobile'
  end

  #签到
  post 'sign' => 'system#sign'
end

