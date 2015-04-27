class Track < ActiveRecord::Base
  scope :next_week, ->(weeks) { where(start: Date.today.weeks_since(weeks).beginning_of_week(start_day = :sunday)..Date.today.weeks_since(weeks).end_of_week(start_day = :sunday)) }
  belongs_to :user
  validates_presence_of :track_type, message: '类型不能为空'
  validates_presence_of :start, message: '开始时间不能为空'
  validates_presence_of :during, message: '持续时间不能为空'

  TYPE = [['跑步', 1], ['自行车', 2], ['綜合训练', 3], ['力量训练', 4],
          ['篮球', 5], ['羽毛球', 6], ['有氧操', 7], ['瑜伽', 8],
          ['步行', 9], ['足球', 10], ['游泳', 11], ['舞蹈', 12],
          ['网球', 13], ['桌球', 14], ['乒乓球', 15], ['棒球', 16]]

  alias_attribute :type, :track_type
  alias_attribute :avail, :places
  alias_attribute :free, :free_places

  def track_type_value
    type_array = TYPE.select { |type|
      type[1].eql?(track_type)
    }
    type_array[0][0]
  end


  def type_name
    for type in TYPE
      return type[0] if track_type.eql?(type[1])
    end
  end

  def as_json
    {
        no: id,
        track_type: type,
        name: name,
        intro: intro,
        address: address,
        start: start.strftime('%Y-%m-%d %H:%M'),
        during: during,
        avail: places-appointments.count,
        free: free
    }
  end

  def summary_json
    {
        no: id,
        type: type,
        name: name,
        start: start.strftime('%Y-%m-%d %H:%M'),
        during: during
    }
  end
end
