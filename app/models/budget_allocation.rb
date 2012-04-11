class BudgetAllocation < ActiveRecord::Base
  attr_accessible :entity_id, :year, :description, :budget_unit_id, :date
  attr_accessible :subfunction_id, :government_program_id, :amount, :personal
  attr_accessible :government_action_id, :foresight, :education, :description
  attr_accessible :expense_nature_id, :capability_id, :goal
  attr_accessible :debt_type, :budget_allocation_type_id, :refinancing, :health
  attr_accessible :alienation_appeal

  attr_modal :year, :description

  has_enumeration_for :debt_type

  belongs_to :entity
  belongs_to :budget_unit
  belongs_to :subfunction
  belongs_to :government_program
  belongs_to :government_action
  belongs_to :expense_nature
  belongs_to :capability
  belongs_to :budget_allocation_type

  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict
  has_many :direct_purchase_budget_allocations, :dependent => :restrict
  has_many :licitation_process_budget_allocations, :dependent => :restrict
  has_many :extra_credit_moviment_types, :dependent => :restrict
  has_many :administrative_process_budget_allocations, :dependent => :restrict

  delegate :function, :function_id, :to => :subfunction, :allow_nil => true

  validates :date, :description, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }
  validates :year, :mask => '9999', :allow_blank => true

  orderize :description
  filterize

  def self.filter(options={})
    relation = scoped
    relation = relation.where { year.eq(options[:year]) } if options[:year].present?
    relation = relation.where { budget_unit_id.eq(options[:budget_unit_id]) } if options[:budget_unit_id].present?
    relation = relation.where { subfunction_id.eq(options[:subfunction_id]) } if options[:subfunction_id].present?
    relation = relation.where { government_program_id.eq(options[:government_program_id]) } if options[:government_program_id].present?
    relation = relation.where { government_action_id.eq(options[:government_action_id]) } if options[:government_action_id].present?
    relation = relation.where { expense_nature_id.eq(options[:expense_nature_id]) } if options[:expense_nature_id].present?
    relation = relation.joins(:subfunction).where { subfunctions.function_id.eq(options[:function_id]) } if options[:function_id].present?
    relation
  end

  def reserved_value
    reserve_funds.collect(&:value).sum
  end

  def real_amount
    (amount || 0) - reserved_value
  end

  def to_s
    "#{id}/#{year} - #{description}"
  end
end
