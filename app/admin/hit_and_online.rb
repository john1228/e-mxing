ActiveAdmin.register_page 'HitAndOnline' do
  menu label: '点击和在线时长', parent: '应用数据'

  content title: '页面点击数和在线时长' do
    tabs do
      tab '0-点击' do
        render partial: 'hits', locals: {
                                  points: HitReport.where(report_date: Date.today.yesterday).order(point: :asc).pluck(:point),
                                  hits: HitReport.where(report_date: Date.today.yesterday).order(point: :asc).pluck(:number),
                              }
      end
      tab '1-时长' do
        render partial: 'online', locals: {
                                    period: OnlineReport.where(report_date: Date.today.yesterday).order(period: :asc).pluck(:period),
                                    online: OnlineReport.where(report_date: Date.today.yesterday).order(period: :asc).pluck(:number)
                                }
      end
    end
  end
  sidebar '条件' do
    div class: 'panel_contents' do
      form do
        div class: 'buttons' do
          input class: 'button', type: 'submit', value: '过滤'
          a href: '#', class: 'clear_filters_btn', value: '清除'
        end
      end
    end
  end
end
