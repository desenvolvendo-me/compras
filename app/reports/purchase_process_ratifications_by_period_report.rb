class PurchaseProcessRatificationsByPeriodReport < Report
  attr_accessor :type_of_purchase, :object_type, :modality, :creditor_id, :creditor,
                :start_date, :end_date, :type_of_removal

  has_enumeration_for :type_of_purchase, :with => PurchaseProcessTypeOfPurchase,
    :create_helpers => true, create_scopes: true
  has_enumeration_for :object_type, :with => PurchaseProcessObjectType, :create_helpers => true
  has_enumeration_for :modality, :create_helpers => true, :create_scopes => true
  has_enumeration_for :type_of_removal, create_helpers: { prefix: true }

  protected

  def normalize_attributes
    params = {}

    params[:type_of_purchase] = type_of_purchase unless type_of_purchase.blank?
    params[:object_type] = object_type unless object_type.blank?
    params[:modality] = modality unless modality.blank?
    params[:type_of_removal] = type_of_removal unless type_of_removal.blank?
    params[:creditor_id] = creditor_id unless creditor_id.blank?
    params[:between_dates] = [start_date.to_date..end_date.to_date] if start_date.presence && end_date.presence

    params
  end
end
