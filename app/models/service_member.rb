class ServiceMember < ActiveRecord::Base
  belongs_to :service, class_name: User, foreign_key: :service_id
  belongs_to :user
end
