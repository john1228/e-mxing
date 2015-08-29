ActiveAdmin.register_page 'Version' do
  menu label: '配置', parent: '运营'
  content title: '版本信息' do
    tabs do
      tab '0-安卓' do
        render partial: 'android', locals: {android: VERSION['android']}
      end
      tab '1-苹果' do
        render partial: 'ios', locals: {ios: VERSION['ios']}
      end
      tab '2-图库分类' do
        render partial: 'tag', locals: {tags: TAGS}
      end
      tab '3-开通城市' do
        render partial: 'city', locals: {city: CITY}
      end
    end

  end
  controller do
    def update
      message = '设置完成'
      case params['type']
        when 'android'
          VERSION['android'] = {'c' => params[:c], 'b' => params[:b]}
          begin
            File.open(Rails.root.to_s + '/config/deploy_config/version.yml', 'w') { |f|
              f.puts VERSION.ya2yaml
            }
          rescue => err
            message = err.message
          end
        when 'ios'
          VERSION['ios'] = {'c' => params[:c], 'b' => params[:b]}
          begin
            File.open(Rails.root.to_s + '/config/deploy_config/version.yml', 'w') { |f|
              f.puts VERSION.ya2yaml
            }
          rescue => err
            message = err.message
          end
        when 'tag'
          TAGS.clear
          params[:tag].split(',').each { |tag|
            TAGS << tag
          }
          begin
            File.open(Rails.root.to_s + '/config/deploy_config/gallery.yml', 'w') { |f|
              f.puts TAGS.ya2yaml
            }
          rescue => err
            message = err.message
          end
        when 'city'
          CITY['opened'] = params[:opened].split(',')
          CITY['opened'] = params[:opening].split(',')
          begin
            File.open(Rails.root.to_s + '/config/deploy_config/city.yml', 'w') { |f|
              f.puts CITY.ya2yaml
            }
          rescue => err
            message = err.message
          end
      end

      redirect_to admin_version_path, alert: message
    end
  end
end
