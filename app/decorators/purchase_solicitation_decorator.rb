# encoding: utf-8
class PurchaseSolicitationDecorator
  include Decore
  include Decore::Routes
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :budget_structure, :responsible, :service_status, :to_s => false, :link => :code_and_year

  def quantity_by_material(material_id)
    number_with_precision super if super
  end

  def not_editable_message
    t('purchase_solicitation.messages.not_editable') unless editable?
  end

  def not_annullable_message
    t('purchase_solicitation.messages.not_annullable') if direct_purchase.present?
  end

  def is_annulled_message
    t('purchase_solicitation.messages.is_annulled') if annulled?
  end
end
