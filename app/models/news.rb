class News < ActiveRecord::Base
  before_save :create_html

  attr_accessor :content

  mount_uploader :cover, NewsCoverUploader

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        url: url
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
    fh.puts '<title>html Page</title>'
    fh.puts '</head>'
    fh.puts '<body>'
    fh.puts content
    fh.puts '</body>'
    fh.puts '</html>'
    fh.close
    self.url = html_name
  end
end
