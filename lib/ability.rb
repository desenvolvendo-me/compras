class Ability
  include CanCan::Ability

  def initialize(user = nil)
    alias_action :read, :create, :update, :to => :modify
    alias_action :edit, :filter, :modal, :to => :read
    alias_action :modal, :modal_info, :to => :search

    return unless user

    can :access, :accounts
    can :access, :bookmarks

    if user.administrator?
      can :access, :all
    elsif user.creditor?
      can [:read, :update], :price_collection_proposals
    else
      user.roles.each do |role|
        can role.permission.to_sym, role.controller.to_sym
        authorize_dependencies(role.controller.to_sym)
      end
    end
  end

  private

  def authorize_dependencies(controller)
    dependencies(controller).each do |dependency|
      can :search, dependency
    end
  end

  def dependencies(controller)
    belongs_to_dependencies(controller) + configured_dependencies.fetch(controller, [])
  end

  def belongs_to_dependencies(controller)
    begin
      controller.to_s.classify.constantize.reflect_on_all_associations(:belongs_to).map(&:plural_name)
    rescue NameError
      []
    end
  end

  def configured_dependencies
    @configured_dependencies ||= load_configured_dependencies
  end

  def load_configured_dependencies
    YAML.load_file("#{Rails.root}/config/authorization_dependencies.yml").symbolize_keys
  end
end
