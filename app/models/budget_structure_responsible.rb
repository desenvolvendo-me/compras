class BudgetStructureResponsible < Accounting::Model
  include CustomData
  reload_custom_data

  belongs_to :budget_structure
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :regulatory_act

  def status
    if end_date.blank? && start_date.present? && Date.current >= start_date
      Status::ACTIVE
    else
      Status::INACTIVE
    end
  end
end
