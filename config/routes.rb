Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :reports

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #视频首页
  get 'groups' => 'groups#index'
  #验证码
  post 'captcha/regist' => 'captcha#regist'
  post 'captcha/change' => 'captcha#change'
  post 'captcha/check' => 'captcha#check'
  #用户登录和注册
  put 'users' => 'users#update'
  post 'users/login' => 'users#login'
  post 'users/sns' => 'users#sns'
  delete 'users' => "users#logout"
  post 'users/complete' => 'users#complete'
  #个人资料
  get 'profile' => 'profile#index'
  put 'profile' => 'profile#update'
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
  post 'like/dynamic' => 'like#dynamic'
  #评论
  get 'comments' => 'comments#show'
  post 'comments' => 'comments#create'
  #发现
  get 'find/:type' => 'find#list'
  post 'find' => 'find#upload'


  #web路由
  get 'home/index' => 'home#index'
  get 'home/about' => 'home#about'
  get 'home/dynamic' => 'home#dynamic'
  get 'home/contact' => 'home#contact'
  get 'home/join' => 'home#join'
  get 'wap' => 'wap#index'
  get 'wap/film' => 'wap#film'
  get 'wap/course' => 'wap#course'
  root 'home#index'
end

