class ProfilesController < CrudController
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
end
