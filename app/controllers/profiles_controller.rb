class ProfilesController < CrudController
  after_filter :clear_menu, :only => [:update, :destroy], :if => :use_cache?

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

  def clear_menu
    expire_fragment("compras-menu-#{current_customer.cache_key}-profile-id-#{current_user.profile_id}")
  end

  def use_cache?
    Rails.env.production? || Rails.env.training? || Rails.env.staging?
  end
end
