class Captcha < ActiveRecord::Base
  before_save :generate_captcha

  private
  def generate_captcha
    sample_str = %w"0 1 2 3 4 5 6 7 8 9"
    self.captcha = sample_str.sample(6).join('')
  end

end
