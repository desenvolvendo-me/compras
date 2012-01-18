module Dashboard::PropertyHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.property_variable_settings
      m.property_setting
      m.urban_services
      m.property_correction_factors
      m.category_point_constructions
      m.properties
      m.contribution_improvement_types
      m.contribution_improvement_reasons
      m.contribution_improvement_situations
      m.contribution_improvements
      m.property_transfers
    end
  end
end
