module PrefecturesHelper
  def sidebar_menu
    simple_menu do |m|
      m.cities
      m.neighborhoods
      m.streets
      m.districts
      m.land_subdivisions
      m.condominiums
    end
  end
end
