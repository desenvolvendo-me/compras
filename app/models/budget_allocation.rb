class BudgetAllocation < Accounting::Model
  include BelongsToResource

  belongs_to :descriptor
  belongs_to :function
  belongs_to :subfunction
  belongs_to :government_program
  belongs_to :government_action

  belongs_to_resource :expense_nature

  belongs_to_resource :budget_structure

  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict
  has_many :extra_credit_moviment_types, :dependent => :restrict
  has_many :pledge_liquidations, :through => :pledges
  has_many :pledge_cancellations, :through => :pledges
  has_many :payments, :through => :pledges
  has_many :budget_allocation_capabilities, :dependent => :destroy, :inverse_of => :budget_allocation
  has_many :capabilities, :through => :budget_allocation_capabilities

  has_one :budget_structure_configuration, through: :budget_structure

  delegate :expense_nature, :description, :kind, :to => :expense_nature, :allow_nil => true, :prefix => true
  delegate :code, :budget_structure, :structure_sequence, :to => :budget_structure, :prefix => true, :allow_nil => true
  delegate :code, :to => :function, :prefix => true, :allow_nil => true
  delegate :code, :to => :subfunction, :prefix => true, :allow_nil => true
  delegate :code, :to => :government_program, :prefix => true, :allow_nil => true
  delegate :code, :action_type, :to => :government_action, :prefix => true, :allow_nil => true

  orderize :code

  scope :term, lambda { |q|
    where { code.eq("#{q}") }
  }

  scope :by_year, ->(year) { where(year: year) if year.present? }

  scope :budget_structure_id, lambda { |budget_structure_id|
    where { |budget_allocation|
      budget_allocation.budget_structure_id.eq(budget_structure_id)
    }
  }

  def reserved_value
    reserve_funds.sum { |reserved_fund| reserved_fund.amount } -
      reserve_funds.with_pledges.sum { |reserved_fund| reserved_fund.amount }
  end

  def balance
    amount - reserved_value - pledges_balance
  end

  def to_s
    "#{code} - #{expense_nature.to_s}"
  end

  def autocomplete_budget_allocation
    "#{code} - #{expense_nature_description}"
  end

  def capability
    capabilities.map(&:to_s).uniq.join(', ')
  end

  def months_sum
    months_values.values.map{ |i| pt_to_en_float(i) }.sum
  end

  def amount
    capability_total
  end

  private

  def pledges_balance
    pledges.sum(&:balance)
  end

  def capability_total
    budget_allocation_capabilities.reject{ |capability|
      capability.marked_for_destruction? || capability.amount.blank?
    }.map(&:amount).sum
  end
end
