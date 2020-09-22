class PriceCollectionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year,:purchase_solicitation,:department,:status

  def purchase_solicitation
    self.purchase_solicitations.last
  end

  def department
    self.purchase_solicitations.last.department if self.purchase_solicitations.last
  end

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

  def must_have_proposals
    return if component.price_collection_proposals.any?

    t("price_collection.messages.must_have_proposals")
  end
end
