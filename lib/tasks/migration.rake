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
    service = Service.first
    csv_text = File.read("#{Rails.root}/" + 'member.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      mobile = row[4]
      name = row[2]
      card_name = row[1]
      end_date = Date.parse(row[10])
      open_date = Date.parse(row[9])
      value = (end_date-open_date).floor
      seller = row[5]
      pay_amount = row[6]
      order_no = row[7]
      create_date = row[8]
      physical_card = row[12]
      #美型用户
      user = User.find_by(mobile: mobile)
      if user.blank?
        user = User.new(mobile: mobile)
        user.save
      end
      #会员信息
      member = user.members.find_by(service: service, name: name, mobile: mobile)
      if member.blank?
        member = user.members.new(service: service, name: name, mobile: mobile)
        member.save
      end
      #会员卡信息
      membership_card = member.cards.new(service: service,
                                         card_type: 'clocked', name: card_name,
                                         open: open_date,
                                         value: value, status: 'normal', physical_card: physical_card, created_at: create_date, updated_at: create_date)
      if membership_card.save
        log = membership_card.logs.buy.new(change_amount: value, pay_amount: pay_amount, pay_type: 'other', seller: seller, remark: '合同编号-'+ order_no.to_s, created_at: create_date, updated_at: create_date)
        log.save
      end
    end
  end
end