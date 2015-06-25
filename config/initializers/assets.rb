# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w(service.css
 ckeditor/*
 webchat/webim.css
 webchat/bootstrap.css
 wap/wap.css
 web/web.css
 home/home.js
 style.css
 share.css
 share/style.css
 share/mini.css

 home/jquery.touchSlider.js
 home/jquery-1.7.1.min.js
 webchat/bootstrap.js
 webchat/easemob.im-1.0.5.js
 webchat/jquery-1.11.1.js
 webchat/json2.js
 webchat/strophe-custom-2.0.0.js
 share/*
 hls.min.js
 )