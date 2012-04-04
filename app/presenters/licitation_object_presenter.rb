# encoding: utf-8
class LicitationObjectPresenter < Presenter::Proxy
  def purchase_licitation_exemption_with_precision
    helpers.number_with_precision(object.purchase_licitation_exemption)
  end

  def build_licitation_exemption_with_precision
    helpers.number_with_precision(object.build_licitation_exemption)
  end
end
