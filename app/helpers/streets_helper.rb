module StreetsHelper
  def sidebar_menu
    simple_menu do |m|
      m.street_types
      m.neighborhoods
    end
  end
end
