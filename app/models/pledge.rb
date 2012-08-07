class Pledge < Compras::Model
  attr_accessible :descriptor_id, :management_unit_id, :emission_date, :pledge_type
  attr_accessible :budget_allocation_id, :value, :pledge_category_id, :expense_kind_id
  attr_accessible :pledge_historic_id, :contract_id, :licitation_modality_id
  attr_accessible :description, :licitation, :process, :reserve_fund_id, :material_kind
  attr_accessible :founded_debt_contract_id, :creditor_id, :pledge_items_attributes
  attr_accessible :licitation_process_id, :expense_nature_id

  attr_readonly :code

  auto_increment :code, :by => :descriptor_id

  attr_accessor :licitation, :process, :item_replicated_value, :parcel_replicated_value

  attr_modal :code, :descriptor_id, :emission_date, :management_unit_id,
             :budget_allocation_id, :creditor_id

  has_enumeration_for :material_kind
  has_enumeration_for :pledge_type, :create_helpers => true

  belongs_to :descriptor
  belongs_to :creditor
  belongs_to :reserve_fund
  belongs_to :management_unit
  belongs_to :budget_allocation
  belongs_to :pledge_category
  belongs_to :expense_kind
  belongs_to :pledge_historic
  belongs_to :contract
  belongs_to :founded_debt_contract, :class_name => 'Contract'
  belongs_to :licitation_modality
  belongs_to :licitation_process
  belongs_to :expense_nature

  has_many :pledge_items, :dependent => :destroy, :inverse_of => :pledge, :order => :id
  has_many :pledge_cancellations, :dependent => :restrict
  has_many :pledge_liquidations, :dependent => :restrict

  accepts_nested_attributes_for :pledge_items, :allow_destroy => true

  delegate :signature_date, :to => :contract, :allow_nil => true, :prefix => true
  delegate :value, :to => :reserve_fund, :allow_nil => true, :prefix => true
  delegate :amount, :real_amount, :expense_nature, :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :licitation_number, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :expense_category_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_group_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_modality_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_element_id, :to => :budget_allocation, :allow_nil => true
  delegate :entity, :year, :to => :descriptor, :allow_nil => true
  delegate :expense_nature_expense_nature, :to => :budget_allocation, :allow_nil => true

  validates :descriptor, :budget_allocation, :management_unit, :presence => true
  validates :emission_date, :pledge_type, :value, :creditor, :presence => true
  validates :expense_nature, :presence => true
  validates :code, :uniqueness => { :scope => [:descriptor_id], :allow_blank => true }
  validates :pledge_items, :no_duplication => :material_id
  validate :value_should_not_be_greater_than_budget_allocation_real_amount
  validate :items_total_value_should_not_be_greater_than_value

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :licitation, :process, :format => /^(\d+)\/\d{4}$/
    allowing_blank.validates :emission_date,
      :timeliness => {
        :on_or_after => :today,
        :on_or_after_message => :should_be_on_or_after_today,
        :type => :date,
        :on => :create
      }
  end

  orderize :emission_date
  filterize accessible_attributes + [:id]

  def self.global_or_estimated
    where { pledge_type.eq(PledgeType::GLOBAL) | pledge_type.eq(PledgeType::ESTIMATED) }
  end

  def to_s
     "#{code} - #{entity}/#{year}"
  end

  def items_total_value
    pledge_items.sum(&:estimated_total_price)
  end

  def balance
    value - pledge_cancellations_sum - pledge_liquidations_sum
  end

  def pledge_liquidations_sum
    pledge_liquidations.total_value_by_activated
  end

  def pledge_cancellations_sum
    pledge_cancellations.sum(:value)
  end

  protected

  def value_should_not_be_greater_than_budget_allocation_real_amount(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless value && budget_allocation_real_amount

    if value > budget_allocation_real_amount
      errors.add(:value, :must_not_be_greater_than_budget_allocation_real_amount_with_reserved_values, :value => numeric_parser.localize(budget_allocation_real_amount))
    end
  end

  def items_total_value_should_not_be_greater_than_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    if value && items_total_value > value
      errors.add(:items_total_value, :should_not_be_greater_than_pledge_value, :value => numeric_parser.localize(items_total_value))
    end
  end

  def licitation?
    licitation_number && licitation_year
  end

  def process?
    process_number && process_year
  end
end
