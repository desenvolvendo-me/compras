class Pledge < Accounting::Model
  include CustomData
  reload_custom_data

  attr_accessor :licitation, :process, :item_replicated_value, :parcel_replicated_value

  attr_modal :year, :code, :emission_date,
             :budget_allocation_id, :creditor_id

  has_enumeration_for :material_kind

  belongs_to :descriptor
  belongs_to :creditor
  belongs_to :special_inscription
  belongs_to :reserve_fund
  belongs_to :management_unit
  belongs_to :budget_allocation
  belongs_to :pledge_category
  belongs_to :expense_kind
  belongs_to :accounting_historic
  belongs_to :contract
  belongs_to :founded_debt_contract, :class_name => 'Contract'
  belongs_to :expense_nature
  belongs_to :precatory
  belongs_to :capability
  belongs_to :main_pledge, :class_name => 'Pledge'

  has_many :pledge_items, :dependent => :destroy, :inverse_of => :pledge, :order => :id
  has_many :pledge_cancellations, :dependent => :restrict
  has_many :supply_orders, dependent: :restrict

  accepts_nested_attributes_for :pledge_items, :allow_destroy => true

  alias_attribute :date, :emission_date

  delegate :signature_date, :amendment_numbers, :to => :contract,
           :allow_nil => true, :prefix => true
  delegate :amount, :to => :reserve_fund, :allow_nil => true, :prefix => true
  delegate :amount, :balance, :expense_nature, :expense_nature_id,
           :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :expense_nature_expense_nature, :expense_nature_kind, :to => :budget_allocation, :allow_nil => true
  delegate :advance_or_subsidy_or_agreement?, :to => :pledge_category, :allow_nil => true

  delegate :budget_structure, :function, :subfunction, :government_program,
           :government_action, :expense_nature, :add_extra_credit_sum,
           :subtract_extra_credit_sum, :total_by_extra_credit,
           :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :address, :cnpj, :name, :city, :state, :phone, :fax, :bank, :agency, :company?,
           :number, :digit, :document, :state_registration, :commercial_registration_number,
           :individual?, :company?, :zip_code, :state_acronym,
           :to => :creditor, :prefix => true, :allow_nil => true
  delegate :functional_code, :function_code, :subfunction_code, :government_program_code,
           :government_action_code, :to => :budget_allocation, :allow_nil => true
  delegate :capability_source, :capability_source_code, :to => :capability, :allow_nil => true
  delegate :code, :to => :main_pledge, :prefix => true, :allow_nil => true
  delegate :contract_number, :to => :contract, :allow_nil => true
  delegate :signature_date, :to => :contract, :prefix => true, :allow_nil => true

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :licitation, :process, :format => /^(\d+)\/\d{4}$/
  end

  orderize :code
  filterize accessible_attributes + [:id]

  scope :opened_parcels, lambda {
    joins { pledge_liquidations }.
    joins { pledge_liquidation_parcels }.
    where { pledge_liquidation_parcels.status.eq(PledgeLiquidationParcelStatus::OPEN) }
  }

  scope :only_leftover_or_pledges, lambda {
    |leftover_pledge| where(:leftover_pledge => leftover_pledge)
  }

  def self.search(params)
    records = scoped
    records = records.where { code.in_any(params[:codes]) } if params[:codes].present?
    records = records.where { descriptor_id.eq(params[:descriptor_id]) } if params[:descriptor_id].present?
    records
  end

  def self.with_available_balance
    joins { pledge_liquidations.outer }.
    joins { pledge_cancellations.outer }.
    where { pledge_liquidations.status.eq(PledgeLiquidationStatus::ACTIVE) | pledge_liquidations.status.eq(nil) }.
    group { id }.group { amount }.
    having { (amount - coalesce(pledge_liquidations.sum(amount), 0) - coalesce(pledge_cancellations.sum(amount), 0)) > 0 }
  end

  def self.with_cancellations_on_date(date)
    select("DISTINCT accounting_pledges.*").
    joins { pledge_cancellations }.
    where { pledge_cancellations.date.in(date.beginning_of_month..date.end_of_month) }
  end

  def self.by_month(month)
    with_year(month.year).by_date(month.beginning_of_month..month.end_of_month)
  end

  def to_s
    "#{code}"
  end

  def self.by_date(range)
    where { emission_date.in(range) }
  end

  def items_total_value
    pledge_items.sum(&:estimated_total_price)
  end

  def balance
    amount - pledge_cancellations_sum - pledge_liquidations_sum
  end

  def pledge_liquidations_sum
    pledge_liquidations.total_amount_by_activated
  end

  def pledge_cancellations_sum
    pledge_cancellations.sum(:amount)
  end

  def pledge_liquidation_parcel_payment_issued_sum
    payments.issued.sum(:amount)
  end

  def unpaid_value
    amount - pledge_liquidation_parcel_payment_issued_sum
  end

  def other_pledges_with_same_budget_allocation_sum
    other_pledges_with_same_budget_allocation.sum(&:balance)
  end

  def pledges_sum_until_now
    other_pledges_with_same_budget_allocation_sum + amount + pledge_cancellations_sum
  end

  def budget_allocation_pledge_balance
    budget_allocation_total_by_extra_credit - pledges_sum_until_now
  end

  def net_amount
    amount - pledge_cancellations_sum
  end

  def has_balance_to_be_liquidated?
    balance > 0
  end

  def pledge_type
    leftover_pledge? ? 'leftover_pledge' : 'pledge'
  end

  protected

  def reserve_fund_budget_allocation_year_equal_year
    return unless year.present? && reserve_fund.present?

    unless reserve_fund.budget_allocation.year == year
      errors.add(:reserve_fund, :must_have_same_year_pledge, :year => year)
    end
  end

  def budget_allocation_year_equal_year
    return unless year.present? && budget_allocation.present?

    unless budget_allocation.year == year
      errors.add(:budget_allocation, :must_have_same_year_pledge, :year => year)
    end
  end

  def expense_nature_year_equal_year
    return unless year.present? && expense_nature.present?

    unless expense_nature.year == year
      errors.add(:expense_nature, :must_have_same_year_pledge, :year => year)
    end
  end

  def other_pledges_with_same_budget_allocation
    query = Pledge.where { |pledge|
      pledge.budget_allocation_id.eq(budget_allocation_id)
    }

    query = query.where { |pledge| pledge.emission_date.lte(emission_date) }
    query = query.where { |pledge| pledge.id.not_eq(id) }
    query
  end

  def value_should_not_be_greater_than_budget_allocation_balance(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless amount && budget_allocation_balance

    if amount > budget_allocation_balance
      errors.add(:amount, :must_not_be_greater_than_budget_allocation_real_amount_with_reserved_values, :value => numeric_parser.localize(budget_allocation_balance))
    end
  end

  def items_total_value_should_not_be_greater_than_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    if amount && items_total_value > amount
      errors.add(:items_total_value, :should_not_be_greater_than_pledge_value, :value => numeric_parser.localize(items_total_value))
    end
  end

  def accounting_historic_kind_must_be_pledges
    return unless accounting_historic

    unless accounting_historic.pledges?
      errors.add(:accounting_historic, :accounting_historic_kind_must_be_pledges)
    end
  end

  def creditor_or_special_inscription_required
    if creditor.blank? && special_inscription.blank?
      errors.add(:base, :creditor_or_special_inscription_cannot_be_blank)
      errors.add(:creditor, "")
      errors.add(:special_inscription, "")
    end
  end

  def expense_nature_must_be_son_of_budget_allocation_expense_nature
    return if expense_nature.blank? || budget_allocation_expense_nature.blank? ||
      budget_allocation_expense_nature.analytical?

    if expense_nature.parent != budget_allocation_expense_nature
      errors.add(:expense_nature, :expense_nature_must_be_son_of_budget_allocation_expense_nature)
    end
  end

  def expense_nature_must_be_equal_of_budget_allocation_expense_nature
    return if expense_nature.blank? || budget_allocation_expense_nature.blank? ||
      not(budget_allocation_expense_nature.analytical?)

    if expense_nature != budget_allocation_expense_nature
      errors.add(:expense_nature, :expense_nature_must_be_equal_of_budget_allocation_expense_nature)
    end
  end

  def at_least_one_item
    if pledge_items.empty?
      errors.add(:pledge_items, :should_be_at_least_one_item)
    end
  end

  def emission_date_equal_to_year
    return unless year.present? && emission_date.present?
    errors.add(:emission_date, :must_be_equals_to_year, :year => year) if year != emission_date.year
  end

  def initial_value_sum_equal_to_amount
    return unless initial_value_not_processed.present? && initial_value_processed.present? && amount.present?
    errors.add(:amount, :should_equal_to_sum_initial_values) if leftover_pledge? && amount != (initial_value_not_processed + initial_value_processed)
  end

  def year_less_than_or_equal_to_descriptor_year
    return unless year.present? && descriptor.present?
    errors.add(:year, :less_than, :count => descriptor.year) if year >= descriptor.year && leftover_pledge?
    errors.add(:year, :equal_to, :count => descriptor.year) if year != descriptor.year && !leftover_pledge?
  end

  def emission_date_must_not_be_less_than_last_emission_date
    return unless emission_date

    date = last_emission_date

    if date && emission_date < date
      errors.add(:emission_date, :must_not_be_greater_than_or_equal_last_moviment_date, :date => I18n.l(date))
    end
  end

  def last_emission_date
    Pledge.where(:descriptor_id => descriptor_id)
          .order("emission_date DESC")
          .pluck(:emission_date)
          .first
  end
end
