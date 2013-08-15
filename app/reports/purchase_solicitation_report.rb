class PurchaseSolicitationReport < Report
  attr_accessor :budget_structure, :budget_structure_id, :kind, :status, :material,
    :material_id, :start_date, :end_date, :type_report

  has_enumeration_for :kind, :with => PurchaseSolicitationKind
  has_enumeration_for :status, :with => PurchaseSolicitationServiceStatus
  has_enumeration_for :type_report, create_helpers: true

  validates :start_date, :end_date, :type_report, :presence => true

  def records_grouped
    records.
      joins { items.material }.
      select { sum(items.quantity).as(:quantity) }.
      select { sum(items.quantity * items.unit_price).as(:total) }.
      select { budget_structure_id }.
      select { items.material_id }.
      group { budget_structure_id }.
      group { items.material_id }.
      order("budget_structure_id, material_id")
  end

  def item(record, material_repository = Material)
    material_repository.find record.material_id
  end

  def record_code_year(record, purchase_solicitation_repository = PurchaseSolicitation)
    purchase_solicitation = purchase_solicitation_repository.find(record.id)

    "#{purchase_solicitation.code}/#{purchase_solicitation.accounting_year}"
  end

  private

  def normalize_attributes
    params = {}

    params[:budget_structure_id] = budget_structure_id unless budget_structure_id.blank?
    params[:kind] = kind unless kind.blank?
    params[:status] = status unless status.blank?
    params[:material_id] = material_id unless material_id.blank?
    params[:between_dates] = [start_date.to_date..end_date.to_date] if start_date.presence && end_date.presence

    params
  end
end
