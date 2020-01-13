class PurchaseSolicitationDecorator
  include Decore
  include Decore::Routes
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :department, :user, :service_status

  def expense
    self.purchase_form.nil? || self.purchase_form.expense.nil? ? '':"#{self.purchase_form.expense}"
  end

  def organ
    self.purchase_form.nil? || self.purchase_form.organ.nil? ? '':"#{self.purchase_form.organ}"
  end

  def unity
    self.purchase_form.nil? || self.purchase_form.unity.nil? ? '':"#{self.purchase_form.unity}"
  end

  def reference_expense
    self.purchase_form.nil? ? '':"#{self.purchase_form.reference_expense}"
  end

  def description_project_activity
    self.purchase_form.nil? ? '':"#{self.purchase_form.description_project_activity}"
  end

  def nature_expense
    self.purchase_form.nil? || self.purchase_form.expense.nil? || self.purchase_form.expense.nature_expense.nil? ? '':"#{self.purchase_form.expense.nature_expense.nature}"
  end

  def resource_source
    self.purchase_form.nil? || self.purchase_form.expense.nil? || self.purchase_form.expense.resource_source.nil? ? '':"#{self.purchase_form.expense.resource_source.to_s}"
  end

  def description_resource_source
    self.purchase_form.nil? || self.purchase_form.expense.nil?  || self.purchase_form.expense.resource_source.nil? ? '':"#{self.purchase_form.expense.resource_source.name}"
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

  def linked_demand
    t('purchase_solicitation.messages.linked_demand') if self.demand
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
