module Dashboard::AccountancyHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.administractive_acts
      m.classification_of_types_of_administractive_acts
      m.expense_economic_classifications
      m.organogram_configurations
      m.budget_allocations
      m.legal_text_natures
      m.organograms
      m.administration_types
      m.type_of_administractive_acts
    end
  end
end
