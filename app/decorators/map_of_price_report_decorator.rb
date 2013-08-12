#encoding: utf-8
class MapOfPriceReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def lot_header(lot, proposal_items)
    "Lote: #{lot} - Quantidade: #{proposal_items.count}"
  end

  def creditor_data(creditor)
    "#{creditor.identity_document} - #{creditor.name}"
  end

  def item_unit_price(item)
    number_to_currency(item.unit_price) if item.unit_price
  end

  def item_total_price(item)
    number_to_currency(item.total_price) if item.total_price
  end

  def item_average_unit_price(proposal_items)
    number_to_currency(proposal_items.sum(&:unit_price) / proposal_items.count)
  end

  def item_average_total_price(proposal_items)
    number_to_currency(proposal_items.sum(&:total_price) / proposal_items.count)
  end
end
