class SettingsController < CrudController
  before_filter :update_settings, :only => :index

  protected

  def update_settings
    settings_updater = SettingsUpdater.new
    settings_updater.update
  end
end
