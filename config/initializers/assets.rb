# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( wap/wap.css web/web.css home/home.js home/jquery.touchSlider.js home/jquery-1.7.1.min.js)