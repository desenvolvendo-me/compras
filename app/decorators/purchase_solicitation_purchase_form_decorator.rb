class PurchaseSolicitationPurchaseFormDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper


  attr_header :purchase_form, :purchase_solicitation

end
