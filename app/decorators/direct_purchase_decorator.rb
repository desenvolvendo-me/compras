# encoding: utf-8
class DirectPurchaseDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def total_allocations_items_value
    number_with_precision super if super
  end

  def is_annulled_message
    t('direct_purchase.messages.is_annulled') if annulled?
  end

  def code_and_year
    "#{code}/#{year}"
  end

  def subtitle
    code_and_year
  end
end
