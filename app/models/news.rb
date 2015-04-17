class News < ActiveRecord::Base
  before_save :create_html

  attr_accessor :content

  mount_uploader :cover, NewsCoverUploader

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        width: 690,
        height: 790,
        url: $host+'/html/news/'+url
    }
  end

  private
  def create_html
    html_name = "#{Time.now.strftime('%Y%m%dT%H%M%S')}.html"
    fh = File.new("#{Rails.root}/public/html/news/#{html_name}", 'w')
    fh.puts '<html>'
    fh.puts '<head>'
    fh.puts '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>'
    fh.puts '<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0 , maximum-scale=1.0, user-scalable=0">'
    fh.puts '<link rel="stylesheet" type="text/css" href="../css/style.css"/>'
    fh.puts '<title>资讯</title>'
    fh.puts '</head>'
    fh.puts '<body>'
    fh.puts '<section class="article">'
    fh.puts '<div class="artzt">'
    fh.puts "<h1>#{title}</h1>"
    fh.puts "<em>美型新闻 #{Time.now.strftime('%m-%d %H:%M')}</em>"
    fh.puts '</div>'
    fh.puts '<div class="artcon">' + content + '</div>'
    fh.puts '</section>'
    fh.puts '</body>'
    fh.puts '</html>'
    fh.close
    self.url = html_name
  end
end
