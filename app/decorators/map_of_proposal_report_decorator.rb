class MapOfProposalReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def average_unit_price_item(item)
    number_to_currency super(item) if super(item)
  end

  def average_total_price_item(item)
    number_to_currency super(item) if super(item)
  end
end
