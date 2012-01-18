module LandSubdivisionsHelper
  def sidebar_menu
    simple_menu do |m|
      m.neighborhoods
      m.districts
    end
  end
end
