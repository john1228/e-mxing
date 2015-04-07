role :app, %w{root@www.e-mxing.com} #服务器地址
role :web, %w{root@www.e-mxing.com}
role :db, %w{root@www.e-mxing.com}
server 'www.e-mxing.com', user: 'root', roles: %w{web app}

set :deploy_to, '/mnt/www/e-mxing' #部署的位置

# PUMA
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix:///tmp/example.sock" #根据nginx配置链接的sock进行设置，需要唯一
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 16]
set :puma_workers, 0
set :puma_init_active_record, false
set :puma_preload_app, true