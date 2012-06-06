class Pledge < ActiveRecord::Base
  attr_accessible :entity_id, :year, :management_unit_id, :emission_date, :pledge_type
  attr_accessible :budget_allocation_id, :value, :pledge_category_id, :expense_kind_id
  attr_accessible :pledge_historic_id, :management_contract_id, :licitation_modality_id
  attr_accessible :description, :licitation, :process, :reserve_fund_id, :material_kind
  attr_accessible :founded_debt_contract_id, :provider_id, :pledge_items_attributes
  attr_accessible :pledge_parcels_attributes, :licitation_process_id

  attr_accessor :licitation, :process, :item_replicated_value, :parcel_replicated_value

  has_enumeration_for :material_kind
  has_enumeration_for :pledge_type, :create_helpers => true

  belongs_to :provider
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
  belongs_to :licitation_process

  has_many :pledge_items, :dependent => :destroy, :inverse_of => :pledge, :order => :id
  has_many :pledge_parcels, :dependent => :destroy, :order => :number
  has_many :pledge_cancellations, :dependent => :restrict
  has_many :pledge_liquidations, :dependent => :restrict
  has_many :pledge_liquidation_cancellations, :dependent => :restrict
  has_many :subpledges, :dependent => :restrict, :order => :number
  has_many :subpledge_cancellations, :dependent => :restrict

  accepts_nested_attributes_for :pledge_items, :allow_destroy => true
  accepts_nested_attributes_for :pledge_parcels, :allow_destroy => true

  delegate :signature_date, :to => :management_contract, :allow_nil => true, :prefix => true
  delegate :value, :to => :reserve_fund, :allow_nil => true, :prefix => true
  delegate :amount, :real_amount, :function, :subfunction, :government_program, :government_action,
           :budget_structure, :expense_nature,
           :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :licitation_number, :to => :licitation_process, :allow_nil => true, :prefix => true

  validates :licitation_process, :entity, :year, :management_unit, :presence => true
  validates :emission_date, :pledge_type, :value, :provider, :presence => true
  validates :budget_allocation, :presence => true
  validate :value_should_not_be_greater_than_budget_allocation_real_amount
  validate :items_total_value_should_not_be_greater_than_value
  validate :cannot_have_more_than_once_item_with_the_same_material
  validate :parcels_should_have_date_greater_than_or_equals_emission_date
  validate :parcels_should_have_date_greater_than_last_parcel_date
  validate :pledge_parcels_value_should_be_equals_value

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => '9999'
    allowing_blank.validates :licitation, :process, :format => /^(\d+)\/\d{4}$/
    allowing_blank.validates :emission_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create }
  end

  orderize :emission_date
  filterize accessible_attributes + [:id]

  scope :has_subpledges, joins { subpledges }

  def self.global_or_estimated
    where { pledge_type.eq(PledgeType::GLOBAL) | pledge_type.eq(PledgeType::ESTIMATED) }
  end

  def to_s
    id.to_s
  end

  def pledge_parcels_sum
    pledge_parcels.map(&:value).compact.sum
  end

  def items_total_value
    pledge_items.sum(&:estimated_total_price)
  end

  def pledge_parcels_with_balance
    pledge_parcels.select { |pledge_parcel| pledge_parcel.balance > 0 }
  end

  def pledge_parcels_with_liquidations
    pledge_parcels.select { |pledge_parcel| pledge_parcel.liquidations_value > 0 }
  end

  def balance
    value - pledge_cancellations_sum - liquidation_value - subpledges_value_sum
  end

  def pledge_liquidations_sum
    pledge_liquidations.sum(:value)
  end

  def subpledges_sum
    pledge_parcels.map(&:subpledges_sum).compact.sum
  end

  def liquidation_value
    pledge_liquidations_sum - pledge_liquidation_cancellations_sum
  end

  def pledge_cancellations_sum
    pledge_cancellations.sum(:value)
  end

  def pledge_liquidation_cancellations_sum
    pledge_liquidation_cancellations.sum(:value)
  end

  def subpledges_value_sum
    subpledges.compact.sum(&:balance)
  end

  def last_subpledge
    subpledges.last
  end

  def subpledges?
    subpledges.any?
  end

  protected

  def pledge_parcels_value_should_be_equals_value
    return unless value

    if pledge_parcels_sum != value
      errors.add(:pledge_parcels_sum, :pledge_parcels_sum_must_be_equals_to_pledge_value)
    end
  end

  def parcels_should_have_date_greater_than_last_parcel_date
    last_parcel = nil

    pledge_parcels.each do |parcel|
      if last_parcel && parcel.expiration_date && parcel.expiration_date < last_parcel.expiration_date
        parcel.errors.add(:expiration_date, :must_be_greater_than_last_expiration_date)
        errors.add(:pledge_parcels, :invalid)
      end

      last_parcel = parcel
    end
  end

  def parcels_should_have_date_greater_than_or_equals_emission_date
    pledge_parcels.each do |parcel|
      next unless emission_date && parcel.expiration_date && parcel.expiration_date < emission_date

      parcel.errors.add(:expiration_date, :must_be_greater_than_or_equals_pledge_emission_date)
      errors.add(:pledge_parcels, :invalid)
    end
  end

  def value_should_not_be_greater_than_budget_allocation_real_amount
    return unless value && budget_allocation_real_amount

    errors.add(:value, :must_not_be_greater_than_budget_allocation_real_amount_with_reserved_values) if value > budget_allocation_real_amount
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
