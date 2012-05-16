# encoding: utf-8
class LicitationObjectDecorator < Decorator
  attr_modal :description, :year

  def purchase_licitation_exemption_with_precision
    helpers.number_with_precision(component.purchase_licitation_exemption)
  end

  def build_licitation_exemption_with_precision
    helpers.number_with_precision(component.build_licitation_exemption)
  end
end
