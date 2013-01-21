class PurchaseSolicitationItemGroupDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :description, :status

  def allow_submit_button?
    !annulled? && editable?
  end

  def allow_annul_link?
    annulled? || annullable?
  end

  def not_allow_submit_message
    prefix = 'purchase_solicitation_item_group.messages.not_allow_submit'

    return t("#{ prefix }.annulled") if annulled?
    t("#{ prefix }.not_editable") unless editable?
  end

  def not_annullable_message
    return if annulled?

    t("purchase_solicitation_item_group.messages.not_annullable") unless editable?
  end
end
