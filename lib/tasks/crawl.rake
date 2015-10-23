namespace :crawl do
  task :dianping do
    options = {:accept_cookies => true,
               :read_timeout => 20,
               :retry_limit => 0,
               :verbose => true,
               :discard_page_bodies => true,
               :user_agent => 'Mozilla...'}

    city = %w"'http://www.dianping.com/beijing/sports'
 'http://www.dianping.com/tianjin/sports'
 'http://www.dianping.com/shenyang/sports'
 'http://www.dianping.com/dalian/sports'
 'http://www.dianping.com/changchun/sports'
 'http://www.dianping.com/haerbin/sports'
 'http://www.dianping.com/shijiazhuang/sports'
 'http://www.dianping.com/taiyuan/sports'
 'http://www.dianping.com/huhehaote/sports'
 'http://www.dianping.com/langfang/sports'
 'http://www.dianping.com/shanghai/sports'
 'http://www.dianping.com/hangzhou/sports'
 'http://www.dianping.com/nanjing/sports'
 'http://www.dianping.com/suzhou/sports'
 'http://www.dianping.com/wuxi/sports'
 'http://www.dianping.com/jinan/sports'
 'http://www.dianping.com/xiamen/sports'
 'http://www.dianping.com/ningbo/sports'
 'http://www.dianping.com/fuzhou/sports'
 'http://www.dianping.com/qingdao/sports'
 'http://www.dianping.com/hefei/sports'
 'http://www.dianping.com/changzhou/sports'
 'http://www.dianping.com/yangzhou/sports'
 'http://www.dianping.com/wenzhou/sports'
 'http://www.dianping.com/shaoxing/sports'
 'http://www.dianping.com/jiaxing/sports'
 'http://www.dianping.com/yantai/sports'
 'http://www.dianping.com/weihai/sports'
 'http://www.dianping.com/zhenjiang/sports'
 'http://www.dianping.com/nantong/sports'
 'http://www.dianping.com/jinhua/sports'
 'http://www.dianping.com/xuzhou/sports'
 'http://www.dianping.com/weifang/sports'
 'http://www.dianping.com/zibo/sports'
 'http://www.dianping.com/linyi/sports'
 'http://www.dianping.com/maanshan/sports'
 'http://www.dianping.com/zhejiangtaizhou/sports'
 'http://www.dianping.com/taizhou/sports'
 'http://www.dianping.com/jining/sports'
 'http://www.dianping.com/taian/sports'
 'http://www.dianping.com/chengdu/sports'
 'http://www.dianping.com/wuhan/sports'
 'http://www.dianping.com/zhengzhou/sports'
 'http://www.dianping.com/changsha/sports'
 'http://www.dianping.com/nanchang/sports'
 'http://www.dianping.com/guiyang/sports'
 'http://www.dianping.com/xining/sports'
 'http://www.dianping.com/chongqing/sports'
 'http://www.dianping.com/xian/sports'
 'http://www.dianping.com/kunming/sports'
 'http://www.dianping.com/lanzhou/sports'
 'http://www.dianping.com/wulumuqi/sports'
 'http://www.dianping.com/yinchuan/sports'
 'http://www.dianping.com/guangzhou/sports'
 'http://www.dianping.com/shenzhen/sports'
 'http://www.dianping.com/foshan/sports'
 'http://www.dianping.com/zhuhai/sports'
 'http://www.dianping.com/dongguan/sports'
 'http://www.dianping.com/sanya/sports'
 'http://www.dianping.com/haikou/sports'
 'http://www.dianping.com/nanning/sports'
 'http://www.dianping.com/huizhou/sports'"

    city.map { |city_url|
      root_page = Nokogiri::HTML(open('http://www.dianping.com/beijing/sports'))
      root_page.css('li.term-list-item').select { |li|
        if li.css('strong.term').text.eql?('运动分类:')
          li.css('a').map { |category|
            item_list_url = 'http://www.dianping.com'+category['href']
            Anemone.crawl(item_list_url, options) do |items_page|
              items_page.on_every_page do |page|
                shop_list_page = Nokogiri::HTML(page.body)
                shop_list_page.css('div.pic a').map { |detail_url|
                  _detail_url = 'http://www.dianping.com'+ detail_url['href']
                  Anemone.crawl(item_list_url, options) do |detail|

                  end
                }
                break
                # category_list_page.css('div.tit a').map { |detail_url|
                #   _detail_url = 'http://www.dianping.com'+ detail_url['href']
                #   Anemone.crawl(_detail_url, options) do | |
                #   end
                # }
              end
            end
          }
        end
      }
    }
  end
end