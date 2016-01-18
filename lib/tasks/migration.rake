namespace :migration do
  desc '学员'
  task :crawl_data => :environment do
    csv_text = File.read("#{Rails.root}/" + 'crawl-data-2015-11-30-1.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      data_hash = row.to_hash
      photos = nil
      if data_hash['Photo'].present?
        photos = data_hash['Photo'].gsub('[', '')
        photos = photos.gsub(']', '')
        photos = photos.gsub('"', '')
        photos = photos.split(',').map { |item| item.lstrip }
      end
      CrawlDatum.create(
          name: data_hash['Name'],
          avatar: data_hash['Avatar'],
          address: data_hash['Address'],
          tel: data_hash['Tel'],
          business: data_hash['Business'],
          service: data_hash['Service'],
          photo: photos,
          intro: data_hash['Intro'],
          province: data_hash['Province'],
          city: data_hash['City'],
          area: data_hash['Area']
      )
    end
  end

  task :member => :environment do
    csv_text = File.read("#{Rails.root}/" + 'member2.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      PhysicalCard.create(entity_number: row[0], virtual_number: row[1])
    end
  end

  task :member_yoyo => :environment do
    service = Service.find_by_mxid(56031)
    csv_text = File.read("#{Rails.root}/" + 'member.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      card_no = row[0]
      mobile = row[4]
      name = row[2]
      order_no = row[7]
      #会员信息
      member = Members.find_by(service: service, name: name, mobile: mobile)
      if member.blank?
        puts '未查找到该会员'
      else
        member.update(remark: '合同编号-'+order_no+'|'+'原卡号-'+card_no)
        #会员卡信息
        membership_card = member.cards.find_by(service: service)
        membership_card.update(remark: '合同编号-'+order_no+'|'+'原卡号-'+card_no)
      end

    end
  end
end