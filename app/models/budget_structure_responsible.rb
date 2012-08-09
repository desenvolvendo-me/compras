class BudgetStructureResponsible < Compras::Model
  attr_accessible :responsible_id, :regulatory_act_id, :start_date
  attr_accessible :end_date, :status

  has_enumeration_for :status

  belongs_to :budget_structure
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :regulatory_act

  validates :responsible, :regulatory_act, :start_date, :status, :presence => true
  validates :end_date, :timeliness => {
    :after => :start_date,
    :type => :date,
    :after_message => :end_date_should_be_after_start_date
  }, :allow_blank => true
end
