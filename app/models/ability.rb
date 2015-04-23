class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
      when AdminUser::SUPER
        can :manage, :all
      when AdminUser::SERVICE
        can [:read, :update, :destroy], Service, id: user.service_id
        can [:index, :read, :create, :update, :destroy], :ServiceDynamic, service_id: user.service_id
        can [:index, :read, :create, :update, :destroy], :ServiceMember, service_id: user.service_id
        can [:index, :read, :create, :update, :destroy], :ServicePhoto, service_id: user.service_id
        can [:index, :read, :create, :update, :destroy], :ServiceTrack, service_id: user.service_id
      else
        can :manage, :Service
    end
  end
end