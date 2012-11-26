# encoding: utf-8
class DirectPurchaseDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :budget_structure, :creditor, :status

  def total_allocations_items_value
    number_with_precision super if super
  end

  def is_annulled_message
    t('direct_purchase.messages.is_annulled') if annulled?
  end
end
