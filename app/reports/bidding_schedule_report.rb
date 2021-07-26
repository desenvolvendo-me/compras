class BiddingScheduleReport < Report
  include StartEndDatesRange

  attr_accessor :object_type, :modality,  :licitation_commission_id,
    :licitation_commission

  validates :start_date, :end_date, presence: true

  has_enumeration_for :object_type, with: PurchaseProcessObjectType, create_helpers: true
  has_enumeration_for :modality, create_helpers: true, create_scopes: true

  def render_list?
    true
  end

  protected

  def normalize_attributes
    params = {}

    params[:object_type] = object_type unless object_type.blank?
    params[:modality] = modality unless modality.blank?
    params[:between_dates] = [start_date.to_date..end_date.to_date] unless start_date.blank? && end_date.blank?
    params[:licitation_commission_id] = licitation_commission_id unless licitation_commission_id.blank?

    params
  end
end
