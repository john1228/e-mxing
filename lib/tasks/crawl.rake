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

    %W"http://www.dianping.com/beijing/sports".map { |city|
      #抓取运动分类
      city_page = open(city)
      puts city_page
      page = Nokogiri::HTML(open(city))
      items = page.css('li.term-list-item').select { |li| li if li.css('strong.term').text.eql?('运动分类:') }
      category = items.first.css('a').map { |a| host + a['href'] }
      sleep(1)
      category.each { |_category_url|
        shop = []
        category_page = Nokogiri::HTML(agent.get(_category_url).body)
        next_page_url = ((host + category_page.css('div.page a.next')[0]['href']) rescue nil)
        while next_page_url.present?
          next_page = Nokogiri::HTML(agent.get(next_page_url).body)
          shop << next_page.css('div.pic a').map { |a|
            {
                url: host + a['href'],
                avatar: a.css('img')[0]['data-src']
            }
          }
          next_page_url = ((host + next_page.css('div.page a.next')[0]['href']) rescue nil)
          sleep(1)
        end
        sleep(1)
        shop.map { |shop|
          detail = Nokogiri::HTML(agent.get(shop[:url]).body)
          base_info = detail.css('div#basic-info')
          base_info.css('h1.shop-name a').remove
          base_info.css('div.other p.J-park').remove
          base_info.css('div.other p.J-feature').remove
          base_info.css('div.other p.J-Contribution').remove
          begin
            photo = Nokogiri::HTML(agent.get(URI.encode(shop[:url] + '/photos/tag-环境')).body)
            photos = photo.css('div.img a img').map { |image|
              image['src']
            }
          rescue
            photos = []
          end
          CrawlDatum.create(
              name: (base_info.css('h1.shop-name')[0].text).lstrip.rstrip.chop,
              avatar: shop[:avatar],
              address: base_info.css('div.address a')[0].text + base_info.css('div.address span.item')[0].text.lstrip.rstrip.chop,
              tel: base_info.css('p.tel span.item').map { |span| span.text.lstrip.rstrip.chop },
              business: base_info.css('div.other p.info-indent').select { |item| item.css('span.info-name').text.start_with?('营业时间') }[0]['span.item'].text.lstrip.rstrip.chop,
              service: base_info.css('div.other p.info-indent').select { |item| item.css('span.info-name').text.start_with?('分类标签') }.map { |item| item['span.item'].text.lstrip.rstrip.chop },
              photo: photos
          )
          sleep(1)
        }

      }
    }
  end
end