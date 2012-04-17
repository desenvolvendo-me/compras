# encoding: utf-8
class LicitationObjectPresenter < Presenter::Proxy
  attr_modal :description, :year

  attr_data 'purchase-licitation-exemption' => :purchase_licitation_exemption
  attr_data 'build-licitation-exemption' => :build_licitation_exemption

  def purchase_licitation_exemption_with_precision
    helpers.number_with_precision(object.purchase_licitation_exemption)
  end

  def build_licitation_exemption_with_precision
    helpers.number_with_precision(object.build_licitation_exemption)
  end
end
