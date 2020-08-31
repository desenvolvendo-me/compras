class PriceCollectionProposalDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :creditor, :total_lot_value, :price_collection_date, :status

  def code_and_year
    "#{price_collection_code}/#{price_collection_year}"
  end

  def price_collection_date
    localize(super) if super
  end

  def item_total_value_by_lot(lot)
    number_with_precision super if super
  end

  def only_creditor_is_authorized_message(user)
    t('price_collection_proposal.messages.only_creditor_is_authorized') unless editable_by?(user)
  end

  def total_lot_value
    str = []
    price_collection_lots.each do |lot|
      str << 'lote '+ (lot.to_s) +': '+ number_to_currency(item_total_value_by_lot(lot))
    end

    str.join('/ ')
  end
end
