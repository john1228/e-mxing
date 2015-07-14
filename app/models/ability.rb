class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
      when AdminUser::ROLE[:super]
        can :manage, :all
      when AdminUser::ROLE[:service]
        can [:read, :update, :destroy], Service, id: user.service_id
        can :manage, ServiceDynamic, service: user.service
        can [:read, :create, :update], ServiceMember, service: user.service
        can :manage, ServicePhoto, service: user.service
        can :manage, ServiceTrack, service: user.service
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      when AdminUser::ROLE[:cms]
        can :manage, TypeShow
        can :manage, Activity
        can :manage, News
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      when AdminUser::ROLE[:market]
        can [:read, :create, :update], Service
        can :manage, ServiceDynamic
        can :manage, ServiceMember
        can :manage, ServicePhoto
        can :manage, ServiceTrack
        can [:read, :create, :update], AdminUser
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      when AdminUser::ROLE[:operate]
        can :read, Enthusiast
        can :read, Service
        can :read, ServiceDynamic
        can :read, ServiceMember
        can :read, ServicePhoto
        can :read, Coach
        can :manage, Report
        can :manage, Feedback
        can :manage, Overview
        can :manage, ActiveAdmin::Page, :name => 'HitAndOnline'
        can :manage, Retention
      else
        cannot :manage, :all
    end
  end
end