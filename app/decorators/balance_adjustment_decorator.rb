class BalanceAdjustmentDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper

  attr_header :licitation_process, :purchase_solicitation, :contract

end
