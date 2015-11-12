namespace :crawl do
  task :dianping => :environment do
    host = 'http://www.dianping.com'
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
    %W"http://www.dianping.com/beijing/sports".map { |city|
      #抓取运动分类
      page = Nokogiri::HTML(open(city))
      items = page.css('li.term-list-item').select { |li| li if li.css('strong.term').text.eql?('运动分类:') }
      category = items.first.css('a').map { |a| host + a['href'] }
      sleep(10)
      category.each { |_category_url|
        shop = []
        category_page = Nokogiri::HTML(agent.get(_category_url).body)
        shop += category_page.css('div.pic a').map { |a|
          {
              url: host + a['href'],
              avatar: a.css('img')[0]['data-src']
          }
        }
        next_page_url = ((host + category_page.css('div.page a.next')[0]['href']) rescue nil)
        while next_page_url.present?
          puts "当前页码:#{next_page_url}"
          next_page = Nokogiri::HTML(agent.get(next_page_url).body)
          shop += next_page.css('div.pic a').map { |a|
            {
                url: host + a['href'],
                avatar: a.css('img')[0]['data-src']
            }
          }
          next_page_url = ((host + next_page.css('div.page a.next')[0]['href']) rescue nil)
          sleep(10)
        end
        sleep(10)
        shop.map { |shop_info|
          detail = Nokogiri::HTML(agent.get(shop_info[:url]).body)
          puts "当前店铺地址:#{shop_info[:url]}"
          sleep(10)
          base_info = detail.css('div#basic-info')
          base_info.css('h1.shop-name a').remove
          base_info.css('div.other p.J-park').remove
          base_info.css('div.other p.J-park').remove
          base_info.css('div.other p.J-feature').remove
          base_info.css('div.other p.J-Contribution').remove
          #begin
          shop_name = (base_info.css('h1.shop-name')[0].text).lstrip.rstrip
          avatar = shop_info[:avatar]
          address = base_info.css('div.address a')[0].text.lstrip.rstrip + base_info.css('div.address span.item')[0].text.lstrip.rstrip
          tel = base_info.css('p.tel span.item').map { |span| span.text.lstrip.rstrip }.join(',')
          business = base_info.css('div.other p.info-indent').select { |item| item.css('span.info-name').text.start_with?('营业时间') }.map { |item| item.css('span.item').text.lstrip.rstrip }.join
          service = base_info.css('div.other p.info-indent').select { |item| item.css('span.info-name').text.start_with?('分类标签') }.map { |item|
            item_text = item.css('span.item').text.lstrip.rstrip
            item_text[0, item_text.index('(')]
          }
          tab_titles = detail.css('div#shop-tabs h2.mod-title a').map { |a| a.text.lstrip.rstrip }
          tab_infos = Nokogiri::HTML(detail.css('div#shop-tabs script').text).css('div.J-panel')
          photo = nil
          intro = nil
          tab_titles.each_with_index { |value, index|
            tab_info = tab_infos[index]
            if value.eql?('环境')
              photo = tab_info.css('div.container a img').map { |image| image['src'].gsub('100c100', '1000c1000') }
            elsif value.eql?('品牌故事')
              intro = (tab_info.css('div.info p.J_all')[0].text rescue tab_info.css('div.info p.J_short')[0].text)
            end
          }
          CrawlDatum.create(
              name: shop_name,
              avatar: avatar,
              province: '北京市',
              city: '北京市',
              area: address[0, (address.index('区')||address.index('县')) + 1],
              address: address[(address.index('区')||address.index('县')) + 1, address.length],
              tel: tel,
              business: business,
              service: service,
              photo: photo,
              intro: intro
          )
        }
      }
    }
  end
end