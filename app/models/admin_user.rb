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

  ROLE = {super: 0, service: 1, cms: 2, market: 3, operater: 4}

  def is_service?
    role.eql?(ROLE[:service])
  end

  def is_cms?
    role.eql?(ROLE[:cms])
  end

  def is_market?
    role.eql?(ROLE[:market])
  end
end
