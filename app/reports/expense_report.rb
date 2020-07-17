class ExpenseReport < Report
  attr_accessor :organ, :organ_id, :unity, :unity_id

  def group_unity
    Organ.where(id: records.pluck(:unity_id).reject(&:blank?).uniq)
  end

  def group_project_activity expenses
    ProjectActivity.where(id: expenses.pluck(:project_activity_id).reject(&:blank?).uniq)
  end

  private
  def normalize_attributes
    params = {}

    params[:organ_id] = organ_id if organ_id.present?
    params[:unity_id] = unity_id if unity_id.present?

    params
  end
end