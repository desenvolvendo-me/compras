class ReserveFund < ActiveRecord::Base
  attr_accessible :entity_id, :budget_allocation_id, :year
  attr_accessible :value, :reserve_allocation_type_id, :reserve_allocation_type_id
  attr_accessible :licitation_modality_id, :creditor_id, :status, :date, :historic
  attr_accessible :licitation, :process

  attr_readonly :date

  attr_accessor :licitation, :process

  has_enumeration_for :status, :with => ReserveFundStatus, :create_helpers => true

  belongs_to :entity
  belongs_to :budget_allocation
  belongs_to :reserve_allocation_type
  belongs_to :licitation_modality
  belongs_to :creditor

  has_many :pledges, :dependent => :restrict

  delegate :amount, :function, :subfunction, :government_program, :government_action, :budget_unit,
           :expense_nature, :reserved_value, :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :licitation?, :to => :reserve_allocation_type, :allow_nil => true

  validates :entity, :budget_allocation, :value, :year, :reserve_allocation_type, :date, :presence => true
  validate :value_should_not_exceed_available_reserve

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => '9999'
    allowing_blank.validates :licitation, :process, :format => /^(\d+)\/\d{4}$/
    allowing_blank.validates :date, :timeliness => {
      :on_or_after => lambda { last.date },
      :on_or_after_message => :must_be_greater_or_equal_to_last_date,
      :type => :date,
      :if => :any_reserve_fund?
    }
  end

  before_save :parse_licitation, :parse_process, :clear_licitation_dependent_field_if_is_not_licitation

  orderize :year
  filterize

  def to_s
    "#{id}/#{year}"
  end

  def joined_licitation
    "#{licitation_number}/#{licitation_year}" if licitation_number && licitation_year
  end

  def joined_process
    "#{process_number}/#{process_year}" if process_number && process_year
  end

  protected

  def value_should_not_exceed_available_reserve
    return unless budget_allocation

    if budget_allocation_reserved_value + value > budget_allocation_amount
      errors.add(:value, :should_not_exceed_reserved_value)
    end
  end

  def parse_licitation
    if licitation
      parser = NumberYearParser.new(licitation)
      self.licitation_number = parser.number
      self.licitation_year = parser.year
    end
  end

  def parse_process
    if process
      parser = NumberYearParser.new(process)
      self.process_number = parser.number
      self.process_year = parser.year
    end
  end

  def clear_licitation_dependent_field_if_is_not_licitation
    unless licitation?
      self.licitation_modality_id = nil
      self.licitation_number = nil
      self.licitation_year = nil
    end
  end

  def any_reserve_fund?
    self.class.any?
  end
end
