namespace :crawl do
  task :dianping do
    default_page = Nokogiri::HTML(open('http://www.dianping.com/beijing/sports'))
    cities = default_page.css('div.city-list a').map { |href| href['href'] }
    cities.map { |city_url|
      city_default_page = Nokogiri::HTML(open(city_url))
      city_default_page.css('li.term-list-item').select { |li|
        if li.css('strong.term').text.eql?('运动分类:')
          li.css('a').map { |category_url|
            puts 'http://www.dianping.com'+category_url['href']
            files = open('http://www.dianping.com'+category_url['href'])
            category_page = Nokogiri::HTML(open('http://www.dianping.com'+category_url['href']))
            category_page.css('div.tit a').map { |detail_url|
              detail_page = Nokogiri::HTML(open('http://www.dianping.com'+ detail_url['href']))
              shop = detail_page.css('basic-info')
              name = shop.css('h1.shop-name').text
              puts name

            }
          }
        end
      }
      break
    }
  end
end