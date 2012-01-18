class LinkUpdater
  attr_accessor :link_store, :i18n

  def initialize(link_store = Link, i18n = I18n)
    self.link_store = link_store
    self.i18n = i18n
  end

  def update!
    missing_controllers.each do |controller_name|
      link_store.create!(:controller_name => controller_name)
    end

    left_links.each do |link|
      link.destroy
    end
  end

  protected

  def available_controllers
    i18n.translate("controllers").keys.map(&:to_s)
  end

  def current_controllers
    link_store.all.map(&:controller_name)
  end

  def missing_controllers
    available_controllers - current_controllers
  end

  def left_links
    link_store.all.reject { |link| available_controllers.include?(link.controller_name) }
  end
end
