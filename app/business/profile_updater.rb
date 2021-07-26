class ProfileUpdater
  attr_accessor :profile, :default_permission, :i18n

  def initialize(profile, default_permission = Permission::DENY, i18n = I18n)
    self.profile = profile
    self.default_permission = default_permission
    self.i18n = i18n
  end

  def update
    missing_roles.each do |controller|
      profile.build_role(:controller => controller, :permission => default_permission)
    end

    left_roles.each do |role|
      profile.delete_role(role)
    end
  end

  protected

  def available_roles
    i18n.translate("controllers").keys.map(&:to_s)
  end

  def current_roles
    profile.roles.map(&:controller)
  end

  def missing_roles
    available_roles - current_roles
  end

  def left_roles
    profile.roles.reject { |role| available_roles.include?(role.controller) }
  end
end
