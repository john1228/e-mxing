namespace :crawl do
  task :dianping => :environment do
    host = 'http://www.dianping.com'
    options = {:accept_cookies => true,
               :depth_limit => 1,
               :read_timeout => 20,
               :retry_limit => 0,
               :verbose => true,
               :discard_page_bodies => true,
               :user_agent => 'Mozilla...'}

    # * Linux Firefox (3.6.1)
    # * Linux Konqueror (3)
    # * Linux Mozilla
    # * Mac Firefox (3.6)
    # * Mac Mozilla
    # * Mac Safari (5)
    # * Mac Safari 4
    # * Mechanize (default)
    # * Windows IE 6
    # * Windows IE 7
    # * Windows IE 8
    # * Windows IE 9
    # * Windows Mozilla


    agent = Mechanize.new { |agent| agent.user_agent_alias = 'Linux Mozilla' }

    sleep(10)
    base_info = Nokogiri::HTML(agent.get('http://www.dianping.com/shop/18968550').body)
    tab_titles = base_info.css('div#shop-tabs h2.mod-title a').map { |a| a.text.lstrip.rstrip }
    tab_infos =Nokogiri::HTML(base_info.css('div#shop-tabs script').text).css('div.J-panel')
    tab_titles.each_with_index { |value, index|
      puts "#{index}:#{value}"
      tab_info = tab_infos[index]
      if value.eql?('环境')
        photos = tab_info.css('div.container a img').map { |image| host + image['src'] }
      elsif value.eql?('品牌故事')
        intro = tab_info.css('div.info p.J_all')[0].text
      end
    }

    puts "图片:#{photos}"
    puts "介绍:#{intro}"

    #
    # %W"http://www.dianping.com/beijing/sports".map { |city|
    #   #抓取运动分类
    #   page = Nokogiri::HTML(open(city))
    #   items = page.css('li.term-list-item').select { |li| li if li.css('strong.term').text.eql?('运动分类:') }
    #   category = items.first.css('a').map { |a| host + a['href'] }
    #   sleep(10)
    #   category.each { |_category_url|
    #     shop = []
    #     category_page = Nokogiri::HTML(agent.get(_category_url).body)
    #     shop += category_page.css('div.pic a').map { |a|
    #       {
    #           url: host + a['href'],
    #           avatar: a.css('img')[0]['data-src']
    #       }
    #     }
    #     next_page_url = ((host + category_page.css('div.page a.next')[0]['href']) rescue nil)
    #     while next_page_url.present?
    #       puts "当前页码:#{next_page_url}"
    #       next_page = Nokogiri::HTML(agent.get(next_page_url).body)
    #       shop += next_page.css('div.pic a').map { |a|
    #         {
    #             url: host + a['href'],
    #             avatar: a.css('img')[0]['data-src']
    #         }
    #       }
    #       next_page_url = ((host + next_page.css('div.page a.next')[0]['href']) rescue nil)
    #       sleep(10)
    #     end
    #     sleep(10)
    #     shop.map { |shop_info|
    #       detail = Nokogiri::HTML(agent.get(shop_info[:url]).body)
    #       sleep(10)
    #       base_info = detail.css('div#basic-info')
    #       base_info.css('h1.shop-name a').remove
    #       base_info.css('div.other p.J-park').remove
    #       base_info.css('div.other p.J-feature').remove
    #       base_info.css('div.other p.J-Contribution').remove
    #       begin
    #         shop_name = (base_info.css('h1.shop-name')[0].text).lstrip.rstrip.chop
    #         avatar = shop[:avatar]
    #         address = base_info.css('div.address a')[0].text.lstrip.rstrip + base_info.css('div.address span.item')[0].text.lstrip.rstrip
    #         tel = base_info.css('p.tel span.item')[0].textmap { |span| span.text.lstrip.rstrip }
    #         business = base_info.css('div.other p.info-indent').select { |item| item.css('span.info-name').text.start_with?('营业时间') }.map { |item| item.css('span.item').text.lstrip.rstrip }.join
    #         service = base_info.css('div.other p.info-indent').select { |item| item.css('span.info-name').text.start_with?('分类标签') }.map { |item| item.css('span.item').text.lstrip.rstrip }
    #
    #         tab_titles = base_info.css('div#shop_tabs h2 a').map { |a| a.text.lstrip.rstrip }
    #         tab_infos = base_info.css('div#shop_tabs div')
    #         tab_titles.each_with_index { |value, index|
    #           if value.eql?('环境')
    #             elseif value.eql?('品牌故事')
    #           end
    #         }
    #
    #
    #         CrawlDatum.create(
    #             name: shop_name,
    #             avatar: avatar,
    #             address: address,
    #             tel: tel,
    #             business: business,
    #             service: service,
    #             photo: photos
    #         )
    #       rescue Exception => exp
    #         puts "保存数据失败:#{exp.message}"
    #       end
    #     }
    #   }
    #}
  end
end