module GroupManager
  extend ActiveSupport::Concern

  included do
    before_action :is_owner?, only: [:create, :destroy]
  end
  private
  def is_owner?
    @group = Group.find_by(id: params[:group_id])
    render json: {
               code: 0,
               message: '该群不存在'
           } if @group.blank?

    user = Rails.cache.fetch(request.headers[:token])
    render json: {code: 0, message: '您还未登录,不能进行此操作'} if user.nil?
    render json: {code: 0, message: '您不是群主,不能进行此操作'} unless @group.owner.eql?(user.id)
  end
end
