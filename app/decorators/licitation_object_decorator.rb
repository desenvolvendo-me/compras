# encoding: utf-8
class LicitationObjectDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def purchase_licitation_exemption_with_precision
    number_with_precision component.purchase_licitation_exemption if component.purchase_licitation_exemption
  end

  def build_licitation_exemption_with_precision
    number_with_precision component.build_licitation_exemption if component.build_licitation_exemption
  end
end
