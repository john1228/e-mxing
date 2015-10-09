class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
      when AdminUser::ROLE[:super]
        can :manage, :all
      when AdminUser::ROLE[:service]
        can [:read, :update, :destroy, :transfer, :withdraw], Service, id: user.service_id
        can [:read, :update], AdminUser, id: user.id
        can :manage, ServiceDynamic, service: user.service
        can [:read, :create, :update], ServiceMember, service: user.service
        can :manage, ServicePhoto, service: user.service
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
        can [:read, :create, :update], AdminUser
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      when AdminUser::ROLE[:operator]
        can :manage, Banner
        can :manage, Sku
        can :manage, Coupon
        can :read, Enthusiast
        can :read, Service
        can :read, ServiceDynamic
        can :read, ServiceMember
        can :read, ServicePhoto
        can :manage, ServiceCourse
        can :read, Coach
        can :manage, Report
        can :manage, Feedback
        can :manage, Overview
        can :read, Order
        can :manage, Gallery
        can :manage, Activity
        can :manage, ActiveAdmin::Page, :name => 'Message'
        can :manage, ActiveAdmin::Page, :name => 'HitAndOnline'
        can :manage, Retention
        can :manage, ActiveAdmin::Page, :name => 'Dashboard'
        can :manage, Dynamic
      when AdminUser::ROLE[:partner]
        can :manage, Transaction
        can :read, Withdraw
        can :read, ActiveAdmin::Page, :name => 'Dashboard'
      else
        cannot :manage, :all
    end
  end
end