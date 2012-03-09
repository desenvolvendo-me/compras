module Dashboard::RequestHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.purchase_solicitations
      m.direct_purchases
    end
  end

  def dependencies_links
    simple_menu do |m|
      m.supply_authorizations
      m.materials_classes
      m.entities
      m.communication_sources
      m.dissemination_sources
      m.materials_groups
      m.delivery_locations
      m.materials
      m.service_or_contract_types
    end
  end
end
