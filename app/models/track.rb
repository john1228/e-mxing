class Track < ActiveRecord::Base
  scope :next_week, ->(weeks) { where(start: Date.today.weeks_since(weeks).beginning_of_week(start_day = :sunday)..Date.today.weeks_since(weeks).end_of_week(start_day = :sunday)) }
  belongs_to :user
  validates_presence_of :track_type, message: '类型不能为空'
  validates_presence_of :start, message: '开始时间不能为空'
  validates_presence_of :during, message: '持续时间不能为空'


  alias_attribute :type, :track_type
  alias_attribute :avail, :places
  alias_attribute :free, :free_places

  def type_name
    INTERESTS['items'].select { |item| interests_ary.include?(item['id'].to_s) }.join(',')
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
