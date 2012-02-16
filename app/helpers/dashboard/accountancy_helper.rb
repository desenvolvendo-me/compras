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
      m.budget_allocation_types
      m.budget_allocations
      m.legal_text_natures
      m.organograms
      m.administration_types
      m.administractive_act_types
      m.management_units
      m.functions
      m.subfunctions
      m.capabilities
      m.type_of_administractive_acts
    end
  end
end
