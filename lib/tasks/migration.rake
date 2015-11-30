namespace :migration do
  desc '课程转移'
  task :crawl_data => :environment do
    csv_text = File.read("#{Rails.root}/" + 'crawl-data-2015-11-30-1.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      data_hash = row.to_hash
      CrawlDatum.create(
          name: data_hash['Name'],
          avatar: data_hash['Avatar'],
          address: data_hash['Address'],
          tel: data_hash['Tel'],
          business: data_hash['Business'],
          service: data_hash['Service'],
          photo: data_hash['Photo'],
          intro: data_hash['Intro'],
          province: data_hash['Province'],
          city: data_hash['City'],
          area: data_hash['Area']
      )
    end
  end
end