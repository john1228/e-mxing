namespace :migration do
  desc '课程转移'
  task :crawl_data => :environment do
    csv_text = File.read("#{Rails.root}/" + 'crawl-data-2015-11-30-1.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      CrawlDatum.create(row.to_hash)
    end
  end
end