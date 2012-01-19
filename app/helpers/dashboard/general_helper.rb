module Dashboard::GeneralHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.countries
      m.states
      m.cities
      m.districts
      m.neighborhoods
      m.streets
      m.street_types
      m.land_subdivisions
      m.condominiums
      m.condominium_types
      m.people
      m.banks
      m.agencies
      m.bank_accounts
      m.prefectures
      m.settings
      m.fiscal_years
    end
  end
end
