class BudgetStructureResponsible < Compras::Model
  attr_accessible :responsible_id, :regulatory_act_id, :start_date
  attr_accessible :end_date, :status

  has_enumeration_for :status

  belongs_to :budget_structure
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :regulatory_act

  validates :responsible, :regulatory_act, :start_date, :status, :presence => true
end
