class Device < ActiveRecord::Base
  after_create :build_token

  private
  def build_token
    self.token = SecureRandom.uuid
  end
end
