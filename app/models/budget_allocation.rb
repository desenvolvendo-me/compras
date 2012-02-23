class BudgetAllocation < ActiveRecord::Base
  attr_accessible :entity_id, :year, :description, :organogram_id
  attr_accessible :subfunction_id, :government_program_id
  attr_accessible :government_action_id
  attr_accessible :expense_economic_classification_id, :capability_id
  attr_accessible :description, :goal, :debt_type, :budget_allocation_type_id
  attr_accessible :refinancing, :health, :alienation_appeal, :education
  attr_accessible :foresight, :personal, :date, :amount

  delegate :function, :function_id, :to => :subfunction, :allow_nil => true

  belongs_to :entity
  belongs_to :organogram
  belongs_to :subfunction
  belongs_to :government_program
  belongs_to :government_action
  belongs_to :expense_economic_classification
  belongs_to :capability
  belongs_to :budget_allocation_type
  has_many :purchase_solicitations, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :pledges, :dependent => :restrict

  has_enumeration_for :debt_type

  attr_modal :year, :description

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true
  validates :year, :mask => '9999'

  def to_s
    "#{id}/#{year}"
  end
end
