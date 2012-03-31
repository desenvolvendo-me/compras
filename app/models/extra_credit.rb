class ExtraCredit < ActiveRecord::Base
  attr_accessible :entity_id, :year, :credit_type, :regulatory_act_id
  attr_accessible :credit_date, :extra_credit_nature_id
  attr_accessible :extra_credit_moviment_types_attributes

  attr_accessor :difference

  has_enumeration_for :credit_type, :with => ExtraCreditKind

  belongs_to :entity
  belongs_to :regulatory_act
  belongs_to :extra_credit_nature

  has_many :extra_credit_moviment_types, :dependent => :destroy

  delegate :regulatory_act_type, :publication_date, :to => :regulatory_act, :allow_nil => true
  delegate :kind, :kind_humanize, :to => :extra_credit_nature, :allow_nil => true

  accepts_nested_attributes_for :extra_credit_moviment_types, :allow_destroy => true

  validates :year, :mask => '9999'
  validates :year, :entity, :credit_type, :presence => true
  validates :regulatory_act, :credit_date, :presence => true
  validates :extra_credit_nature, :presence => true
  validates :regulatory_act_id, :uniqueness => { :message => :must_be_uniqueness_on_extra_credit }, :allow_blank => true
  validates :credit_date, :timeliness => {
    :on_or_after => :publication_date,
    :on_or_after_message => :must_be_greather_or_equal_to_publication_date,
    :type => :date
  }, :allow_blank => true, :if => :publication_date
  validate :uniqueness_of_budget_allocation
  validate :uniqueness_of_capability
  validate :validate_difference
  validate :validate_item_value_when_budget_allocation
  validate :must_not_be_less_than_last_extra_credit_date

  before_validation :save_total

  orderize :year
  filterize

  def to_s
    "#{year}"
  end

  protected

  def must_not_be_less_than_last_extra_credit_date
    return unless credit_date

    self_id = self.id

    last = self.class.where { id != self_id }.last

    errors.add(:credit_date, I18n.t('errors.messages.must_not_be_less_than_last_credit_date', :restriction => I18n.l(last.credit_date))) if last && credit_date < last.credit_date
  end

  def validate_difference
    errors.add(:difference, :difference_must_be_equals_to_zero) unless (self.supplement - self.reduced).zero?
  end

  def validate_item_value_when_budget_allocation(numeric_parser = ::I18n::Alchemy::NumericParser)
    extra_credit_moviment_types.each do |item|
      if item.budget_allocation? && item.subtration? && item.value > item.budget_allocation_real_amount
        item.errors.add(:value, I18n.t('errors.messages.must_not_be_greater_than_budget_allocation_real_amount', :value => numeric_parser.localize(item.budget_allocation_real_amount)))
        errors.add(:extra_credit_moviment_types, :invalid)
      end
    end
  end

  def save_total
    self.supplement, self.reduced = 0.0, 0.0

    extra_credit_moviment_types.each do |item|
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

    extra_credit_moviment_types.each do |moviment|
      unless moviment.budget_allocation_id.blank?
        budget_allocations_count[moviment.budget_allocation_id] ||= 0
        budget_allocations_count[moviment.budget_allocation_id] = budget_allocations_count[moviment.budget_allocation_id].to_i + 1
      end
    end

    extra_credit_moviment_types.each do |moviment|
      if budget_allocations_count[moviment.budget_allocation_id].to_i > 1
        moviment.errors.add(:budget_allocation_id, :taken)
        errors.add(:extra_credit_moviment_types, :taken)
      end
    end
  end

  def uniqueness_of_capability
    capabilities_count = Hash.new

    extra_credit_moviment_types.each do |moviment|
      unless moviment.capability_id.blank?
        capabilities_count[moviment.capability_id] ||= 0
        capabilities_count[moviment.capability_id] = capabilities_count[moviment.capability_id].to_i + 1
      end
    end

    extra_credit_moviment_types.each do |moviment|
      if capabilities_count[moviment.capability_id].to_i > 1
        moviment.errors.add(:capability_id, :taken)
        errors.add(:base, :taken)
      end
    end
  end
end
