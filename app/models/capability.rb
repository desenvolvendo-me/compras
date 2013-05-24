class Capability < Accounting::Model
  attr_readonly :entity_id

  attr_modal :description, :kind, :status

  has_enumeration_for :kind, :with => CapabilityKind
  has_enumeration_for :status, :create_helpers => true
  has_enumeration_for :source

  belongs_to :entity
  belongs_to :capability_destination
  belongs_to :tce_specification_capability

  has_many :budget_allocation_capabilities, :dependent => :restrict
  has_many :budget_allocations, :through => :budget_allocation_capabilities
  has_many :extra_credit_moviment_types, :dependent => :restrict
  has_many :budget_revenue_capabilities, :dependent => :restrict
  has_many :budget_revenues, :through => :budget_revenue_capabilities
  has_many :bank_account_capabilities, :dependent => :restrict
  has_many :pledges, :dependent => :restrict

  has_one :capability_source, :through => :tce_specification_capability

  delegate :application_code, :to => :tce_specification_capability,
           :allow_nil => true

  delegate :code, :to => :capability_source, :allow_nil => true, :prefix => true

  orderize :description

  scope :by_entity_id, lambda { |entity_id| where(entity_id: entity_id) if entity_id.present? }
  scope :by_year, lambda { |year| where(year: year) if year.present? }
  scope :by_budget_allocation_id , lambda { |budget_allocation_id|
  joins(:budget_allocation_capabilities).where('accounting_budget_allocation_capabilities.budget_allocation_id = ?', budget_allocation_id) if budget_allocation_id.present? }

  def self.filter(params)
    query = scoped
    query = query.where { description.eq(params[:description]) } if params[:description].present?
    query = query.where { kind.eq(params[:kind]) } if params[:kind].present?
    query = query.where { status.eq(params[:status]) } if params[:status].present?
    query = query.where { year.eq(params[:year]) } if params[:year].present?

    query
  end

  def self.search(params)
    joins{ :entity }.
    joins{ :tce_specification_capability }.
    where(params).
    order{ tce_specification_capability.capability_source_id }.
    order{ id }
  end

  def budgeted_amount(period)
    budget_revenues.inject(0) { |sum, revenue| sum + revenue.amount_for_period(period) }
  end

  def revenue_amount(period)
    budget_revenues.inject(0) { |sum, budget_revenue| sum + budget_revenue.revenue_amount(period) }
  end

  def allocated_amount(period)
    budget_allocations.inject(0) { |sum, allocation| sum + allocation.amount_for_period(period) }
  end

  def pledged_amount(period)
    budget_allocations.inject(0) { |sum, allocation| sum + allocation.pledged_amount(period) }
  end

  def income_difference(period)
    revenue_amount(period) - budgeted_amount(period)
  end

  def expense_difference(period)
    pledged_amount(period) - allocated_amount(period)
  end

  def deficit_profit(period)
    revenue_amount(period) - pledged_amount(period)
  end

  def profit_percentage(period)
    return '-' if pledged_amount(period).zero?

    (deficit_profit(period) * 100.0) / pledged_amount(period)
  end

  def to_s
    description
  end

  def revenue_amount_for(month)
    budget_revenue_capabilities.inject(0) do |sum, budget_revenue_capability|
      sum + budget_revenue_capability.revenue_amount_for(month)
    end
  end

  def revenue_amount_until(month)
    budget_revenue_capabilities.inject(0) do |sum, budget_revenue_capability|
      sum + budget_revenue_capability.revenue_amount_until(month)
    end
  end
end
