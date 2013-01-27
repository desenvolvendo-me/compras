# encoding: utf-8
class PurchaseSolicitationDecorator
  include Decore
  include Decore::Routes
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :budget_structure, :responsible, :service_status

  def quantity_by_material(material_id)
    number_with_precision super if super
  end

  def not_editable_message
    t('purchase_solicitation.messages.not_editable') unless editable?
  end

  def not_annullable_message
    t('purchase_solicitation.messages.not_annullable', :direct_purchase => direct_purchase) if direct_purchase.present?
  end

  def is_annulled_message
    t('purchase_solicitation.messages.is_annulled') if annulled?
  end

  def not_persisted_message
    t('purchase_solicitation.messages.not_persisted') unless persisted?
  end

  def code_and_year
    "#{code}/#{accounting_year}"
  end
end
