# encoding: utf-8
class PurchaseSolicitationDecorator
  include Decore
  include Decore::Routes
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper

  attr_header :budget_structure, :responsible, :service_status

  def quantity_by_material(material_id)
    number_with_precision super if super
  end
end
