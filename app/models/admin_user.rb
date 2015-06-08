class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :service

  SUPER = 0
  SERVICE = 1
  CMS = 2
  MARKET = 3

  def is_service?
    role.eql?(SERVICE)
  end

  def is_cms?
    role.eql?(CMS)
  end

  def is_market?
    role.eql?(MARKET)
  end
end
