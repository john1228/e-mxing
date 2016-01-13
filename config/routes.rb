Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
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

  post 'login/sns' => 'login#sns'
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
  #照片墙
  get 'photos' => 'photos#index'
  post 'photos' => 'photos#create'
  put 'photos' => 'photos#update'
  delete 'photos/:loc' => 'photos#destroy'
  #动态
  get 'dynamics' => 'dynamics#index'
  get 'dynamics/show' => 'dynamics#show'
  get 'dynamics/latest' => 'dynamics#latest'
  post 'dynamics' => 'dynamics#create'
  delete 'dynamics/:id' => 'dynamics#destroy'
  #赞
  post 'likes/:type' => 'like#create'
  get 'likes/:type' => 'like#index'
  get 'likes' => 'like#count'
  #评论
  get 'comments' => 'comments#show'
  post 'comments' => 'comments#create'
  #发现
  get 'find' => 'find#list'
  put 'find/upload' => 'find#upload'
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
  #配置文件
  get 'deploy/ver' => 'deploy#ver'
  get 'deploy/icon' => 'deploy#icon'
  get 'deploy/banner' => 'deploy#banner'
  get 'deploy/json' => 'deploy#json'
  get 'deploy/service' => 'deploy#service'
  get 'deploy/city' => 'deploy#city'
  get 'deploy/online' => 'deploy#online'
  get 'deploy/ads' => 'deploy#ads'
  #系统接口
  post 'feedback' => 'system#feedback'
  post 'report' => 'system#report'
  #web路由
  get 'home/index' => 'home#index'
  get 'home/about' => 'home#about'
  get 'home/dynamic' => 'home#dynamic'
  get 'home/dynamic/:id' => 'home#detail'
  get 'home/contact' => 'home#contact'
  get 'home/join' => 'home#join'
  get 'home/wap' => 'home#wap'

  get 'wap' => 'wap#index'
  get 'wap/film' => 'share/dynamic'
  get 'wap/course' => 'wap#course'

  get 'news/:id' => 'news#show', as: :news_detail
  get 'type_shows/:id' => 'type_shows#show', as: :type_show_detail
  get 'activities/:id' => 'activities#show', as: :activity_detail
  put 'activities/:id' => 'activities#apply', as: :apply_activity
  post 'activities/:id' => 'activities#group', as: :join_in_group_of_activity
  get 'activities' => 'activities#mine'
  #后台路由配置
  get '/admin/withdraws/:id/people' => 'admin/withdraws#people', as: :withdraw_people
  post '/admin/message/push' => 'admin/message#push', as: :push_message
  post '/admin/:type/version' => 'admin/version#update', as: :update_version
  get '/admin/coupons/:type/category' => 'admin/coupons#list'
  post '/admin/service_courses/:id/online' => 'admin/service_courses#online', as: :online
  post '/admin/service_courses/:id/offline' => 'admin/service_courses#offline', as: :offline
  post '/admin/coupons/:id/online' => 'admin/coupons#online', as: :online_coupon
  post '/admin/coupons/:id/offline' => 'admin/coupons#offline', as: :offline_coupon
  post '/admin/services/:id/message' => 'admin/services#message', as: :service_message
  post '/admin/services/:service_id/service_photos/:id' => 'admin/service_photos#delete', as: :delete_service_photo
  get '/admin/orders/:id/user' => 'admin/orders#user', as: :order_user
  get '/admin/coaches/:id/recommend' => 'admin/coaches#recommend', as: :recommend_coach
  post '/admin/coaches/:id/recommend' => 'admin/coaches#recommend_result', as: :submit_recommend_coach, defaults: {format: 'js'} #推荐私教
  delete '/admin/coaches/:id/recommend' => 'admin/coaches#cancel_recommend', as: :cancel_recommend_coach
  post '/admin/skus/:id/recommend' => 'admin/skus#recommend', as: :recommend_course #推荐课程
  delete '/admin/skus/:id/recommend' => 'admin/skus#cancel_recommend', as: :cancel_recommend_course

  get '/admin/news/:id/recommend' => 'admin/news#recommend', as: :recommend_news
  post '/admin/news/:id/recommend' => 'admin/news#submit_recommend', as: :submit_recommend_news, defaults: {format: 'js'}
  #打标签
  get 'admin/news/:id/mark' => 'admin/news#mark', as: :mark_news
  post 'admin/news/:id/mark' => 'admin/news#mark_result', as: :submit_mark_news
  get 'admin/services/:id/mark' => 'admin/services#mark', as: :mark_service
  post 'admin/services/:id/mark' => 'admin/services#mark_result', as: :submit_mark_service
  #服务号转账和提现
  get '/admin/services/:id/transfer' => 'admin/services#transfer', as: :transfer
  post '/admin/services/:id/transfer' => 'admin/services#transfer_result', as: :service_transfer, defaults: {format: 'js'}
  get '/admin/services/:id/withdraw' => 'admin/services#withdraw', as: :withdraw
  post '/admin/services/:id/withdraw' => 'admin/services#withdraw_result', as: :service_withdraw, defaults: {format: 'js'}
  #服务号照片墙管理
  post '/admin/services/:service_id/photos' => 'admin/service_photos#upload', as: :service_photo_upload
  delete '/admin/services/:service_id/photos/:id' => 'admin/service_photos#destroy', as: :service_photo_delete

  get 'download' => 'download#index'
  get 'download/:package' => 'download#index'

  get 'orders/pay' => 'orders#pay'
  get 'webchat' => 'webchat#index'
  get 'share/:id/dynamics' => 'share#dynamic'
  get 'share/:id/service' => 'share#service'
  get 'share/:id/course' => 'share#course'
  get 'share' => 'share#show'


  root 'home#index'

  get 'appointments' => 'appointments#index'
  get 'appointments/day' => 'appointments#day'


  namespace :business do
    #登录
    post 'login' => 'login#mobile'
    post 'login/auto' => 'login#auto_login'

    namespace :courses do
      get '/' => 'home#index'
      get 'list/:type' => 'home#index'
      get '/:id' => 'home#show'
      post '/' => 'home#create'
      put '/' => 'home#update'
      delete ':id' => 'home#destroy'
    end

    namespace :membership_cards do
      get '/' => 'home#index'
      get '/:id' => 'home#show'
    end

    namespace :face_to_faces do
      get ':type' => 'home#index'
      post 'courses' => 'home#create'
      get 'mxing' => 'home#mxing'
      get ':card/discount' => 'home#discount'
      get 'paid' => 'home#paid'
    end

    namespace :integrals do
      get '/' => 'home#show'
      get 'detail' => 'home#detail'
    end
    namespace :reports do
      get '/' => 'report#daily'
    end
    namespace :schedules do
      get '/' => 'home#index'
      post ':type' => 'home#create'
      delete ':id' => 'home#destroy'
      get 'mine/course' => 'courses#mine'
      get 'student/course' => 'courses#student'
    end
    namespace :students do
      get ':type' => 'home#index'
      post '/' => 'home#create'
      delete ':type/:id' => 'home#destroy'

      get ':mxid/courses' => 'courses#index'
    end

    namespace :shop do
      get '/' => 'home#index'
      get '/help' => 'home#help'
    end

    #评论
    get 'comments' => 'comments#index'
    #打卡
    get 'clocks' => 'clocks#index'
    post 'clocks' => 'clocks#create'
    #私教信息
    get '/' => 'home#index'
    post '/' => 'home#password'
    put '/' => 'home#update'
    #地址管理
    get 'addresses' => 'addresses#index'
    get 'lessons' => 'lessons#index'
    get 'lessons/records' => 'lessons#records'
    get 'lessons/show' => 'lessons#show'
    post 'lessons' => 'lessons#update'
    #预约
    get 'appointments' => 'appointments#index'
    get 'appointments/show' => 'appointments#show'
    post 'appointments' => 'appointments#create'
    put 'appointments' => 'appointments#cancel'
    #订单
    get 'orders' => 'orders#index'
    get 'orders/show' => 'orders#show'
    #钱包
    get 'wallet' => 'wallet#index'
    get 'wallet/coupons' => 'wallet#coupons'
    get 'wallet/detail' => 'wallet#detail'
    post 'wallet' => 'wallet#withdraw'

    post 'feedback' => 'system#feedback'
  end

  namespace :agency do
    get '' => 'agencies#list'
    get 'hot' => 'agencies#hot'
    get 'profile' => 'profiles#show'
    #查看课程和购买
    get 'courses' => 'courses#index'
  end

  namespace :gyms do
    #查看课程和购买
    get 'courses' => 'courses#index'
    get 'courses/show' => 'courses#show'
    get 'courses/coach' => 'courses#coach'
    post 'courses' => 'courses#buy'
    get 'profile' => 'profiles#show'
    #查看评论
    get ':list/comments' => 'comments#index'
  end

  namespace :fan do
    get 'profile' => 'profiles#show'
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
    # get 'lessons' => 'lessons#index'
    # get 'lessons/un_confirm' => 'lessons#un_confirm'
    # put 'lessons' => 'lessons#confirm'
    # post 'lessons/comment' => 'lessons#comment'
    # delete 'lessons/:id' => 'lessons#destroy'
    #V3课时
    get 'classes/:type' => 'classes#index'
    get 'classes/:type/detail' => 'classes#show'
    post 'classes/comment' => 'classes#comment'
    #钱包
    get 'wallet' => 'wallet#index'
    get 'wallet/coupons' => 'wallet#coupons'
    get 'wallet/detail' => 'wallet#detail'
    put 'wallet' => 'wallet#exchange'
    #设置
    put 'setting' => 'setting#update'
    #赞信息
    get 'likes/most' => 'likes#most'
    get 'likes/latest' => 'likes#latest'
    #优惠券信息
    get 'coupons' => 'coupons#index'
    get ':mxid/cards' => 'cards/home#service_card'
    namespace :cards do
      get '/' => 'home#index'
      get ':type' => 'home#index'
      post ':id' => 'checkin#create'
    end
  end

  namespace :callback do
    post 'alipay' => 'alipay#callback'
    post 'jd' => 'jd#callback'
    post 'webchat' => 'webchat#callback'
    get 'qiniu' => 'qiniu#callback'
    post 'qiniu' => 'qiniu#callback'
  end

  namespace :shop do
    get 'buyers' => 'buyers#index'
    get '' => 'courses#index'
    get 'courses' => 'courses#show'
    get 'comments' => 'comments#index'
    post 'courses' => 'courses#pre_order'
    put 'courses' => 'courses#confirm_order'
    get 'recommends/:type' => 'recommends#index'
    get 'coupons' => 'coupons#index'
    post 'coupons' => 'coupons#update'
    get 'coupons/help' => 'coupons#help'
  end

  namespace :api do
    get '' => 'home#index'
    get 'search' => 'home#search'
    get 'hot' => 'home#hot_key'
    #领取优惠券
    post 'coupons' => 'coupons#update'
    #首页入口
    get '/boutique' => 'recommend#boutique'
    get '/gyms' => 'recommend#gyms'
    get '/talent' => 'recommend#talent'
    get '/knowledge' => 'recommend#knowledge'
    get '/coupon' => 'recommend#coupon'
    get '/recommend/venues' => 'recommend#venues'

    get 'orders/:no' => 'orders#show'
    post 'orders' => 'orders#confirm'

    namespace :venues do
      get '' => 'home#index'
      get 'profile' => 'profile#show'
      get 'coaches' => 'coaches#index'
      get 'courses' => 'courses#index'
      get 'comments' => 'comments#index'
      get 'comments/latest' => 'comments#latest'
      post 'comments' => 'comments#create'
    end
    namespace :gyms do
      get 'profile' => 'profile#show'
      get 'courses' => 'courses#index'
      get 'comments' => 'comments#index'
    end
    namespace :fan do
      get 'profile' => 'profile#show'
    end
    namespace :dynamics do
      get '/' => 'home#index'
      post '/' => 'home#create'
      get '/show' => 'home#show'
      delete '/:id' => 'home#destroy'

      get 'comments' => 'comments#index'
      post 'comments' => 'comments#create'
    end
    namespace :course do
      get '/' => 'home#index'
      get '/:sku/info' => 'home#show'
      get 'show' => 'home#show_old'
      get 'search' => 'home#search'
      post 'coupons' => 'home#coupons'
      put 'coupons' => 'home#confirm_order'

      get 'comments' => 'comments#index'
      post 'comments' => 'comments#create'

      get 'news' => 'news#index'
      get 'news/top' => 'news#top'

      namespace :strategies do
        get '' => 'home#index'
        post '' => 'home#create'
        get '/comments' => 'comments#index'
        get '/comments/latest' => 'comments#latest'
        post '/comments' => 'comments#create'
      end
    end
  end

  #发现
  namespace :discovery do
    get 'news' => 'news#index'
    get 'images' => 'images#index'
    get 'dynamics' => 'dynamics#index'
  end

  namespace :h5 do
    get 'login' => 'login#mobile'
    namespace :activity do
      get '/' => 'home#index'
      get '/:id' => 'home#show'
      get '/:id/comments' => 'comments#index'
      post '/:id/comments' => 'comments#create'
      namespace :mine do
        get '/join' => 'home#join'
        get '/release' => 'home#release'
        post '' => 'home#create'
        get '/:id/applies' => 'applies#index'
      end
    end
  end
  #废弃的接口，暂时不删除
  #-----
  get 'showtime' => 'discard/showtime#show'
  get 'services/coaches' => 'services#coaches'
  #------

  #数据上传
  post 'active' => 'upload#active'
  post 'auto_login' => 'upload#auto_login'
  post 'upload' => 'upload#data'
  #发现图片和活动
  get 'find/:type' => 'find#list'
  get 'find/:type/:tag' => 'find#list'
  #签到
  post 'sign' => 'system#sign'

  get 'wap/qrcode' => 'wap#qrcode'
  get 'wap/alipay' => 'wap#alipay'
  get 'wap/pay' => 'wap#pay', as: :pay_order

end

