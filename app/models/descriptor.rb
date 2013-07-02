class Descriptor < Accounting::Model
  attr_modal :year

  has_many :budget_allocations, :dependent => :restrict
  has_many :extra_credits, :dependent => :restrict
  has_many :management_units, :dependent => :restrict
  has_many :accounting_historics, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict
  has_many :budget_revenues, :dependent => :restrict
  has_many :checkbooks, :dependent => :restrict
  has_many :bank_reconciliation_kinds, :dependent => :restrict
  has_many :bank_reconciliations, :dependent => :restrict
  has_many :bank_transfers, :dependent => :restrict
  has_many :tax_revenues, :dependent => :restrict
  has_many :contracts, :dependent => :restrict
  has_many :account_plan_configurations, :dependent => :restrict
  has_many :extra_budget_revenues, :dependent => :restrict
  has_many :extra_budget_revenue_annuls, :dependent => :restrict
  has_many :extra_budget_pledges, :dependent => :restrict
  has_many :extra_budget_pledge_payments, :through => :extra_budget_pledges
  has_many :extra_budget_pledge_reversals, :through => :extra_budget_pledges

  localize :period, :using => MonthAndYearParser

  orderize :period

  def self.filter(options)
    query = scoped
    query = query.where { entity_id.eq(options[:entity_id]) } if options[:entity_id].present?
    query = query.by_year(options[:year].to_i) if options[:year].present?
    query
  end

  def self.by_year(value)
    where(:year => value)
  end

  def period=(value)
    write_attribute(:period, value)
    self.year = period && period.year
  end

  def month
    period.try(:month)
  end
end
