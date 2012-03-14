class Pledge < ActiveRecord::Base
  attr_accessible :entity_id, :year, :management_unit_id, :emission_date, :pledge_type
  attr_accessible :budget_allocation_id, :value, :pledge_category_id, :expense_kind_id
  attr_accessible :pledge_historic_id, :management_contract_id, :licitation_modality_id
  attr_accessible :description, :licitation, :process, :reserve_fund_id, :material_kind
  attr_accessible :founded_debt_contract_id, :creditor_id, :pledge_items_attributes

  attr_accessor :licitation, :process

  has_enumeration_for :material_kind
  has_enumeration_for :pledge_type

  belongs_to :creditor
  belongs_to :founded_debt_contract
  belongs_to :entity
  belongs_to :reserve_fund
  belongs_to :management_unit
  belongs_to :budget_allocation
  belongs_to :pledge_category
  belongs_to :expense_kind
  belongs_to :pledge_historic
  belongs_to :management_contract
  belongs_to :licitation_modality

  has_many :pledge_items, :dependent => :destroy, :inverse_of => :pledge, :order => :id

  accepts_nested_attributes_for :pledge_items, :reject_if => :all_blank, :allow_destroy => true

  delegate :signature_date, :to => :management_contract, :allow_nil => true, :prefix => true
  delegate :value, :to => :reserve_fund, :allow_nil => true, :prefix => true
  delegate :amount, :real_amount, :function, :subfunction, :government_program, :government_action,
           :organogram, :expense_economic_classification,
           :to => :budget_allocation, :allow_nil => true, :prefix => true

  validates :year, :mask => '9999'
  validates :emission_date, :timeliness => { :on_or_after => Date.current, :type => :date }
  validates :licitation, :process, :entity, :year, :management_unit, :presence => true
  validates :emission_date, :pledge_type, :value, :creditor, :presence => true
  validates :budget_allocation, :presence => true
  validates :licitation, :process, :format => /^(\d+)\/\d{4}$/, :allow_blank => true

  validate :value_should_not_be_greater_than_budget_allocation_real_amount
  validate :items_total_value_should_not_be_greater_than_value
  validate :cannot_have_more_than_once_item_with_the_same_material

  before_save :parse_licitation, :parse_process

  orderize :emission_date
  filterize

  def to_s
    id.to_s
  end

  def joined_licitation
    "#{licitation_number}/#{licitation_year}" if licitation?
  end

  def joined_process
    "#{process_number}/#{process_year}" if process?
  end

  def items_total_value
    pledge_items.map(&:estimated_total_price).compact.sum
  end

  protected

  def parse_licitation
    parser = NumberYearParser.new(licitation)
    self.licitation_number = parser.number
    self.licitation_year = parser.year
  end

  def parse_process
    parser = NumberYearParser.new(process)
    self.process_number = parser.number
    self.process_year = parser.year
  end

  def value_should_not_be_greater_than_budget_allocation_real_amount
    return unless value && budget_allocation_real_amount

    errors.add(:value, :must_not_be_greather_than_budget_allocation_real_amount) if value > budget_allocation_real_amount
  end

  def items_total_value_should_not_be_greater_than_value
    if value && items_total_value > value
      errors.add(:items_total_value, :should_not_be_greater_than_pledge_value)
    end
  end

  def cannot_have_more_than_once_item_with_the_same_material
    single_materials = []

    pledge_items.each do |item|
      if single_materials.include?(item.material_id)
        errors.add(:pledge_items)
        item.errors.add(:material_id, :taken)
      end
      single_materials << item.material_id
    end
  end

  def licitation?
    licitation_number && licitation_year
  end

  def process?
    process_number && process_year
  end
end
