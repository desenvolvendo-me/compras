class PriceCollectionProposalDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def price_collection_date
    localize(super) if super
  end

  def item_total_value_by_lot(lot)
    number_with_precision super if super
  end

  def only_creditor_is_authorized_message(user)
    t('price_collection_proposal.messages.only_creditor_is_authorized') unless editable_by?(user)
  end
end
