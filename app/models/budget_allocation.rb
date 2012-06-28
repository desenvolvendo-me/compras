class BudgetAllocation < Compras::Model
  attr_accessible :descriptor_id, :description, :budget_structure_id, :date
  attr_accessible :subfunction_id, :government_program_id, :amount, :personal
  attr_accessible :government_action_id, :foresight, :education, :description
  attr_accessible :expense_nature_id, :capability_id, :goal, :kind
  attr_accessible :debt_type, :budget_allocation_type_id, :refinancing, :health
  attr_accessible :alienation_appeal

  attr_readonly :code

  has_enumeration_for :debt_type
  has_enumeration_for :kind, :with => BudgetAllocationKind, :create_helpers => true

  belongs_to :descriptor
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
  delegate :expense_nature, :to => :expense_nature, :allow_nil => true, :prefix => true
  delegate :expense_category_id, :to => :expense_nature, :allow_nil => true
  delegate :expense_group_id, :to => :expense_nature, :allow_nil => true
  delegate :expense_modality_id, :to => :expense_nature, :allow_nil => true
  delegate :expense_element_id, :to => :expense_nature, :allow_nil => true
  delegate :code, :to => :budget_structure, :prefix => true, :allow_nil => true

  validates :descriptor, :date, :description, :kind, :presence => true
  validates :amount, :presence => true, :if => :divide?
  validates :description, :uniqueness => { :allow_blank => true }
  validates :code, :uniqueness => { :scope => [:descriptor_id] }, :allow_blank => true

  before_create :set_code

  orderize :description
  filterize

  def self.filter(options={})
    relation = scoped
    relation = relation.where { budget_structure_id.eq(options[:budget_structure_id]) } if options[:budget_structure_id].present?
    relation = relation.where { subfunction_id.eq(options[:subfunction_id]) } if options[:subfunction_id].present?
    relation = relation.where { government_program_id.eq(options[:government_program_id]) } if options[:government_program_id].present?
    relation = relation.where { government_action_id.eq(options[:government_action_id]) } if options[:government_action_id].present?
    relation = relation.where { expense_nature_id.eq(options[:expense_nature_id]) } if options[:expense_nature_id].present?
    relation = relation.joins { subfunction }.where { subfunction.function_id.eq(options[:function_id]) } if options[:function_id].present?
    relation = relation.where { descriptor_id.eq(options[:descriptor_id]) } if options[:descriptor_id].present?
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

  protected

  def set_code
    self.code = last_code.succ
  end

  def last_code
    self.class.where { |budget_allocation|
      budget_allocation.descriptor_id.eq(descriptor_id)
    }.maximum(:code).to_i
  end
end
