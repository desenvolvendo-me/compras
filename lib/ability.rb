class Ability
  include CanCan::Ability

  def initialize(user = nil)
    alias_action :read, :create, :update, :to => :modify
    alias_action :filter, :modal, :to => :read

    return unless user

    can :access, :accounts
    can :access, :bookmarks

    if user.administrator?
      can :access, :all
    elsif user.provider?
      can [:read, :update], :price_collection_proposals
    else
      user.roles.each do |role|
        can role.permission.to_sym, role.controller.to_sym
      end
    end
  end
end
