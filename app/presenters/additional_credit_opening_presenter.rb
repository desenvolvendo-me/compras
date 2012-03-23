# encoding: utf-8
class AdditionalCreditOpeningPresenter < Presenter::Proxy
  def publication_date
    helpers.l object.publication_date if object.publication_date
  end
end
