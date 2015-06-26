class Like < ActiveRecord::Base
  before_save :validate_within_month
  DYNAMIC = 1
  PERSON = 2

  private
  def validate_within_month
    liked = where(created_at: Time.now.at_beginning_of_month..Time.now).take
    return false if liked.present?
  end
end
