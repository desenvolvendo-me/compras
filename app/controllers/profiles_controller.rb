class ProfilesController < CrudController
  after_filter :clear_menu, :only => [:update, :destroy], :if => :use_cache?
  before_filter :load_profile_items, only: [:new, :create, :edit, :update]

  def new
    object = build_resource

    profile_updater = ProfileUpdater.new(object)
    profile_updater.update

    super
  end

  def edit
    object = resource

    profile_updater = ProfileUpdater.new(object)
    profile_updater.update

    super
  end

  private

  def update_resource(resource, attributes)
    if super
      resource.touch
    end
  end

  def clear_menu
    expire_fragment("compras-menu-#{current_customer.cache_key}-profile-id-#{current_user.profile_id}")
  end

  def use_cache?
    Rails.production_way?
  end

  def load_profile_items
    @menus = YAML::load(ERB.new(File.read('config/profile.yml')).result)['profile']
  end
end
