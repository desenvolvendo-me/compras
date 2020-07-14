class ExpenseReport < Report
  attr_accessor :organ, :organ_id, :purchasing_unit, :purchasing_unit_id

  def normalize_attributes
    params = {}

    params[:licitation_process_id] = organ_id if organ_id.present?
    params[:creditor_id] = purchasing_unit_id if purchasing_unit_id.present?

    params
  end
end