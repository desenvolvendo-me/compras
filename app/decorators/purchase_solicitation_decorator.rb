class PurchaseSolicitationDecorator
  include Decore
  include Decore::Routes
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :request_date, :department, :user, :service_status

  def purchase_form
     self.purchase_forms.present? ? "#{self.purchase_forms.first.purchase_form.name}" : ""
  end

  def quantity_by_material(material_id)
    number_with_precision super if super
  end

  def not_editable_message
    t('purchase_solicitation.messages.not_editable') unless editable?
  end

  def not_annullable_message
    t('purchase_solicitation.messages.not_annullable') if licitation_processes.any?
  end

  def is_annulled_message
    t('purchase_solicitation.messages.is_annulled') if annulled?
  end

  def licitation_process_started
    t('purchase_solicitation.messages.licitation_process_started') if self.list_purchase_solicitations.any?
  end

  def not_persisted_message
    t('purchase_solicitation.messages.not_persisted') unless persisted?
  end

  def code_and_year
    "#{code}/#{accounting_year}"
  end

  def subtitle
    code_and_year
  end

  def disabled_materials
    return if kind

    t('purchase_solicitation.messages.disabled_materials')
  end
end
