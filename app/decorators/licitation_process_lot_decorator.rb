class LicitationProcessLotDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def winner_proposal_total_price
    number_to_currency super if super
  end
end
