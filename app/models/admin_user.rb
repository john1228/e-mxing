class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  enum gender: [:male, :female]
  enum role: [:super, :admin, :cms, :market, :operator, :superadmin, :sales, :front_desk, :finance, :store_manager, :store_admin]
  mount_uploader :avatar, ProfileUploader

  class << self
    def role_for_select
      roles.map do |key, value|
        [I18n.t("enums.admin_user.role.#{key}"), value]
      end
    end
  end

  def all_services
    Service.where(:client_id => self.id)
  end
end
