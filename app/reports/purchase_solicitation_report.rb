class PurchaseSolicitationReport < Report
  include StartEndDatesRange

  attr_accessor :kind, :status, :material, :material_id, :start_date, :end_date, :report_type, :user, :user_id

  has_enumeration_for :kind, :with => PurchaseSolicitationKind
  has_enumeration_for :status, :with => PurchaseSolicitationServiceStatus
  has_enumeration_for :report_type, create_helpers: true

  validates :report_type, :presence => true

  def records_grouped
    records.
      joins { purchase_solicitation }.
      select { sum(quantity).as(:quantity) }.
      select { sum(quantity * unit_price).as(:total) }.
      select { purchase_solicitation.user_id }.
      select { material_id }.
      group { purchase_solicitation.user_id }.
      group { material_id }
  end

  def item(record, material_repository = Material)
    material_repository.find record.material_id
  end

  def record_code_year(record, purchase_solicitation_repository = PurchaseSolicitation)
    purchase_solicitation = purchase_solicitation_repository.find(record.purchase_solicitation_id)

    "#{purchase_solicitation.code}/#{purchase_solicitation.accounting_year}"
  end

  def render_list?
    true
  end

  private

  def normalize_attributes
    params = {}

    params[:kind] = kind unless kind.blank?
    params[:status] = status unless status.blank?
    params[:material_id] = material_id unless material_id.blank?
    params[:between_dates] = [start_date.to_date..end_date.to_date] if start_date.presence && end_date.presence
    params[:user_id] = user_id unless user_id.blank?

    params
  end
end
