module AgenciesHelper
  def sidebar_menu
    simple_menu do |m|
      m.cities
      m.banks
    end
  end
end
