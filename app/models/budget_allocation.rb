class BudgetAllocation < ActiveRecord::Base
  attr_accessible :entity_id, :year, :description, :organogram_id, :date
  attr_accessible :subfunction_id, :government_program_id, :amount, :personal
  attr_accessible :government_action_id, :foresight, :education, :description
  attr_accessible :expense_economic_classification_id, :capability_id, :goal
  attr_accessible :debt_type, :budget_allocation_type_id, :refinancing, :health
  attr_accessible :alienation_appeal

  attr_modal :year, :description

  has_enumeration_for :debt_type

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
  has_many :reserve_funds, :dependent => :restrict

  delegate :function, :function_id, :to => :subfunction, :allow_nil => true

  validates :description, :presence => true, :uniqueness => true
  validates :year, :mask => '9999'

  orderize :description
  filterize

  def to_s
    "#{id}/#{year}"
  end
end
