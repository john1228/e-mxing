require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/puma'      #因为使用puma做Server，所以要加上这一条

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
