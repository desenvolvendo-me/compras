class BudgetAllocation < Compras::Model
  attr_accessible :entity_id, :year, :description, :budget_structure_id, :date
  attr_accessible :subfunction_id, :government_program_id, :amount, :personal
  attr_accessible :government_action_id, :foresight, :education, :description
  attr_accessible :expense_nature_id, :capability_id, :goal, :code
  attr_accessible :debt_type, :budget_allocation_type_id, :refinancing, :health
  attr_accessible :alienation_appeal, :kind

  has_enumeration_for :debt_type
  has_enumeration_for :kind, :with => BudgetAllocationKind, :create_helpers => true

  belongs_to :entity
  belongs_to :budget_structure
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
  has_many :extra_credit_moviment_types, :dependent => :restrict
  has_many :administrative_process_budget_allocations, :dependent => :restrict

  delegate :function, :function_id, :to => :subfunction, :allow_nil => true
  delegate :expense_category_id, :to => :expense_nature, :allow_nil => true
  delegate :expense_group_id, :to => :expense_nature, :allow_nil => true
  delegate :expense_modality_id, :to => :expense_nature, :allow_nil => true
  delegate :expense_element_id, :to => :expense_nature, :allow_nil => true
  delegate :code, :to => :budget_structure, :prefix => true, :allow_nil => true

  validates :date, :description, :kind, :presence => true
  validates :amount, :presence => true, :if => :divide?
  validates :description, :uniqueness => { :allow_blank => true }
  validates :year, :mask => '9999', :allow_blank => true
  validates :code, :uniqueness => { :scope => [:entity_id, :year] }, :allow_blank => true

  orderize :description
  filterize

  def self.filter(options={})
    relation = scoped
    relation = relation.where { year.eq(options[:year]) } if options[:year].present?
    relation = relation.where { budget_structure_id.eq(options[:budget_structure_id]) } if options[:budget_structure_id].present?
    relation = relation.where { subfunction_id.eq(options[:subfunction_id]) } if options[:subfunction_id].present?
    relation = relation.where { government_program_id.eq(options[:government_program_id]) } if options[:government_program_id].present?
    relation = relation.where { government_action_id.eq(options[:government_action_id]) } if options[:government_action_id].present?
    relation = relation.where { expense_nature_id.eq(options[:expense_nature_id]) } if options[:expense_nature_id].present?
    relation = relation.joins { subfunction }.where { subfunction.function_id.eq(options[:function_id]) } if options[:function_id].present?
    relation
  end

  def reserved_value
    reserve_funds.collect(&:value).sum
  end

  def real_amount
    (amount || 0) - reserved_value
  end

  def to_s
    "#{budget_structure_code} - #{description}"
  end

  def next_code
    last_code.succ
  end

  private

  def last_code
    self.class.where { |budget_allocation|
      budget_allocation.year.eq(year) & budget_allocation.entity_id.eq(entity_id)
    }.maximum(:code).to_i
  end
end
