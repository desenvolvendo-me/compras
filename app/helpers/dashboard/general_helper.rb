module Dashboard::GeneralHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.agencies
      m.neighborhoods
      m.banks
      m.positions
      m.company_sizes
      m.cities
      m.cnaes
      m.condominiums
      m.settings
      m.bank_accounts
      m.districts
      m.states
      m.fiscal_years
      m.employees
      m.risk_degrees
      m.streets
      m.land_subdivisions
      m.currencies
      m.legal_natures
      m.countries
      m.periods
      m.people
      m.stn_ordinances
      m.prefectures
      m.condominium_types
      m.street_types
      m.reference_units
    end
  end
end
