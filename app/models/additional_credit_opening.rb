class AdditionalCreditOpening < ActiveRecord::Base
  attr_accessible :entity_id, :year, :credit_type, :administractive_act_id
  attr_accessible :credit_date, :additional_credit_opening_nature_id
  attr_accessible :additional_credit_opening_moviment_types_attributes
  # attr_accessible :supplement, :reduced

  attr_accessor :difference

  has_enumeration_for :credit_type, :with => AdditionalCreditOpeningCreditType

  belongs_to :entity
  belongs_to :administractive_act
  belongs_to :additional_credit_opening_nature

  has_many :additional_credit_opening_moviment_types, :dependent => :destroy

  delegate :administractive_act_type, :publication_date, :to => :administractive_act, :allow_nil => true
  delegate :kind, :kind_humanize, :to => :additional_credit_opening_nature, :allow_nil => true

  accepts_nested_attributes_for :additional_credit_opening_moviment_types, :allow_destroy => true

  validates :year, :mask => '9999'
  validates :year, :entity, :credit_type, :presence => true
  validates :administractive_act, :credit_date, :presence => true
  validates :additional_credit_opening_nature, :presence => true
  validates :administractive_act_id, :uniqueness => { :message => :must_be_uniqueness_on_additional_credit_opening }, :allow_blank => true
  validates :credit_date, :timeliness => {
    :on_or_after => lambda { last.credit_date },
    :on_or_after_message => :must_be_greather_or_equal_to_last_credit_date,
    :type => :date
  }, :allow_blank => true, :if => :any_additional_credit_opening?
  validates :credit_date, :timeliness => {
    :on_or_after => :publication_date,
    :on_or_after_message => :must_be_greather_or_equal_to_publication_date,
    :type => :date
  }, :allow_blank => true, :if => :publication_date
  validate :uniqueness_of_budget_allocation
  validate :uniqueness_of_capability
  validate :validate_difference
  validate :validate_item_value_when_budget_allocation

  before_validation :save_total

  orderize :year
  filterize

  def to_s
    "#{year}"
  end

  protected

  def any_additional_credit_opening?
    self.class.any?
  end

  def validate_difference
    errors.add(:difference, :invalid) unless (self.supplement - self.reduced).zero?
  end

  def validate_item_value_when_budget_allocation(numeric_parser = ::I18n::Alchemy::NumericParser)
    additional_credit_opening_moviment_types.each do |item|
      if item.budget_allocation? && item.subtration? && item.value > item.budget_allocation_real_amount
        item.errors.add(:value, I18n.t('errors.messages.must_not_be_greater_than_budget_allocation_real_amount', :value => numeric_parser.localize(item.budget_allocation_real_amount)))
        errors.add(:additional_credit_opening_moviment_types, :invalid)
      end
    end
  end

  def save_total
    self.supplement, self.reduced = 0.0, 0.0

    additional_credit_opening_moviment_types.each do |item|
      if item.moviment_type.present? && item.value.present?
        if item.moviment_type.sum?
          self.supplement += item.value
        else item.moviment_type.subtration?
          self.reduced += item.value
        end
      end
    end
  end

  def uniqueness_of_budget_allocation
    budget_allocations_count = Hash.new

    additional_credit_opening_moviment_types.each do |moviment|
      unless moviment.budget_allocation_id.blank?
        budget_allocations_count[moviment.budget_allocation_id] ||= 0
        budget_allocations_count[moviment.budget_allocation_id] = budget_allocations_count[moviment.budget_allocation_id].to_i + 1
      end
    end

    additional_credit_opening_moviment_types.each do |moviment|
      if budget_allocations_count[moviment.budget_allocation_id].to_i > 1
        moviment.errors.add(:budget_allocation_id, :taken)
        errors.add(:additional_credit_opening_moviment_types, :taken)
      end
    end
  end

  def uniqueness_of_capability
    capabilities_count = Hash.new

    additional_credit_opening_moviment_types.each do |moviment|
      unless moviment.capability_id.blank?
        capabilities_count[moviment.capability_id] ||= 0
        capabilities_count[moviment.capability_id] = capabilities_count[moviment.capability_id].to_i + 1
      end
    end

    additional_credit_opening_moviment_types.each do |moviment|
      if capabilities_count[moviment.capability_id].to_i > 1
        moviment.errors.add(:capability_id, :taken)
        errors.add(:base, :taken)
      end
    end
  end
end
