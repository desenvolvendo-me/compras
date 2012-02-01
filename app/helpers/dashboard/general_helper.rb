module Dashboard::GeneralHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.employees
      m.countries
      m.states
      m.communication_sources
      m.configuration_organograms
      m.cities
      m.districts
      m.dissemination_sources
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
      m.service_types
      m.settings
      m.fiscal_years
      m.reference_units
      m.delivery_locations
      m.materials_groups
      m.materials_classes
      m.materials
      m.organograms
      m.type_of_administractive_acts
      m.entities
      m.administractive_acts
      m.administration_types
      m.budget_allocations
      m.purchase_solicitations
    end
  end
end
