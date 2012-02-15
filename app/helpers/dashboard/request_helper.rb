module Dashboard::RequestHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.purchase_solicitations
    end
  end

  def dependencies_links
    simple_menu do |m|
      m.communication_sources
      m.dissemination_sources
      m.service_or_contract_types
      m.delivery_locations
      m.materials
      m.materials_classes
      m.materials_groups
      m.entities
    end
  end
end
