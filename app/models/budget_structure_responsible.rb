class BudgetStructureResponsible < Compras::Model
  attr_accessible :responsible_id, :regulatory_act_id, :start_date
  attr_accessible :end_date

  has_enumeration_for :status

  def status
    if end_date.blank? && start_date.present? && Date.current >= start_date
      Status::ACTIVE
    else
      Status::INACTIVE
    end
  end

  belongs_to :budget_structure
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :regulatory_act

  validates :responsible, :regulatory_act, :start_date, :presence => true
end
