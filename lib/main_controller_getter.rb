class MainControllerGetter
  def initialize(name, permissions_path = Rails.root.join('config', 'permissions.yml'))
    @name = name
    @permissions_path = permissions_path
  end

  def name
    permissions_delegations[@name] || @name
  end

  private

  def permissions_delegations
    @permissions_delegations ||= YAML::load_file(@permissions_path)['permissions']['delegations']
  end
end
