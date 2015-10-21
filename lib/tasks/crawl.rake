namespace :crawl do
  task :dianping do
    Anemone.crawl('http://www.dianping.com/beijing/sports') do |anemone|
      anemone.on_every_page do |page|
        if page.url.to_s.include?('sports')&&!page.url.to_s.include?('?')
          html = Nokogiri::HTML(page.body)
          html_class = html.css('html')[0]['class'] rescue nil
          unless html_class.eql?('G_N')
            types = html.css('ul').select { |type| type['class'] == 'desc Fix' }
            choose_type = types[1].css('li a')
          end
        end
      end
    end
  end
end