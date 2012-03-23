class AdditionalCreditOpening < ActiveRecord::Base
  attr_accessible :entity_id, :year, :credit_type, :administractive_act_id
  attr_accessible :credit_date, :additional_credit_opening_nature_id
  attr_accessible :additional_credit_opening_moviment_types_attributes

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
  validate :uniqueness_of_budget_allocation_or_capability

  def uniqueness_of_budget_allocation_or_capability
    budget_allocations_count = Hash.new
    capabilities_count = Hash.new

    additional_credit_opening_moviment_types.each do |moviment|
      unless moviment.budget_allocation_id.blank?
        budget_allocations_count[moviment.budget_allocation_id] ||= 0
        budget_allocations_count[moviment.budget_allocation_id] = budget_allocations_count[moviment.budget_allocation_id].to_i + 1
      end

      unless moviment.capability_id.blank?
        capabilities_count[moviment.capability_id] ||= 0
        capabilities_count[moviment.capability_id] = capabilities_count[moviment.capability_id].to_i + 1
      end
    end

    additional_credit_opening_moviment_types.each do |moviment|
      if budget_allocations_count[moviment.budget_allocation_id].to_i > 1
        moviment.errors.add(:budget_allocation_id, :taken)
        errors.add(:base, :taken)
      end

      if capabilities_count[moviment.capability_id].to_i > 1
        moviment.errors.add(:capability_id, :taken)
        errors.add(:base, :taken)
      end
    end
  end

  orderize :year
  filterize

  def to_s
    "#{year}"
  end

  protected

  def any_additional_credit_opening?
    self.class.any?
  end
end
