class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
      when AdminUser::SUPER
        can :manage, :all
      when AdminUser::SERVICE
        can [:read, :update, :destroy], Service, id: user.service_id
        can :manage, ServiceDynamic, service: user.service
        can :manage, ServiceMember, service: user.service
        can :manage, ServicePhoto, service: user.service
        can :manage, ServiceTrack, service: user.service
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      when AdminUser::CMS
        can :manage, TypeShow
        can :manage, Activity
        can :manage, News
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      when AdminUser::MARKET
        can [:read, :create, :update], Service
        can :manage, ServiceDynamic
        can :manage, ServiceMember
        can :manage, ServicePhoto
        can :manage, ServiceTrack
        can :manage, AdminUser
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      else
        cannot :manage, :all
    end
  end
end