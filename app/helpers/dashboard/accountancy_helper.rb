module Dashboard::AccountancyHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.administractive_acts
      m.administractive_act_type_classifications
      m.expense_economic_classifications
      m.organogram_configurations
      m.budget_allocations
      m.functions
      m.legal_text_natures
      m.organograms
      m.government_actions
      m.government_programs
      m.capabilities
      m.subfunctions
      m.administractive_act_types
      m.administration_types
      m.budget_allocation_types
      m.commitment_types
      m.management_units
      m.government_actions
      m.pledge_categories
      m.pledge_historics
    end
  end
end
