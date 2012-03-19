# encoding: utf-8
class BidOpeningPresenter < Presenter::Proxy
  def value_estimated
    helpers.number_to_currency(object.value_estimated)
  end
end
