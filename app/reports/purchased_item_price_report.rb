class PurchasedItemPriceReport < Report
  attr_accessor :type_of_purchase, :modality, :start_date, :end_date, :creditor_id, :creditor,
    :licitation_process_id, :licitation_process, :material_id, :material,
    :ignore_items_not_adjudicated, :grouping

  has_enumeration_for :modality, create_helpers: true, create_scopes: true
  has_enumeration_for :type_of_purchase, with: PurchaseProcessTypeOfPurchase,
    create_helpers: true, create_scopes: true
  has_enumeration_for :grouping, with: PurchasedItemPriceReportGrouping

  validates :start_date, :end_date, presence: true

  def records
    super.order { 'id' }
  end

  def group_by_creditor(records)
    records.licitation_process_ratification.creditor
  end

  def group_by_licitation(records)
    records.licitation_process_ratification.licitation_process
  end

  def group_by_material(records)
    records.purchase_process_item.material
  end

  def render_list?
    true
  end

  def start_date
    @start_date ||= I18n.l(Date.today.at_beginning_of_month)
  end

  def end_date
    @end_date ||= I18n.l(Date.today.at_end_of_month)
  end

  private

  def normalize_attributes
    params = {}

    params[:licitation_process_id] = licitation_process_id if licitation_process_id.present?
    params[:creditor_id] = creditor_id if creditor_id.present?
    params[:material_id] = material_id if material_id.present?
    params[:type_of_purchase] = type_of_purchase if type_of_purchase.present?
    params[:modality] = modality if modality.present?
    params[:grouping] = grouping if grouping.present?
    params[:ignore_items_not_adjudicated] = ignore_items_not_adjudicated if ignore_items_not_adjudicated.present?
    params[:between_dates] = [start_date.to_date..end_date.to_date] if start_date.present? && end_date.present?

    params
  end
end
