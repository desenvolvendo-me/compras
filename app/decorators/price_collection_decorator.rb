# encoding: utf-8
class PriceCollectionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :status

  def all_price_collection_classifications_groupped
    all_price_collection_classifications.group_by(&:price_collection_proposal)
  end

  def proposal_for_creditor(creditor)
    price_collection_proposals.find_by_creditor_id(creditor.id)
  end

  def is_annulled_message
    t('price_collection.messages.is_annulled') if annulled?
  end

  def code_and_year
    "#{code}/#{year}"
  end

  def subtitle
    code_and_year
  end
end
