class ReserveFund < ActiveRecord::Base
  attr_accessible :entity_id, :budget_allocation_id, :year
  attr_accessible :value, :reserve_allocation_type_id, :reserve_allocation_type_id
  attr_accessible :licitation_modality_id, :creditor_id, :status, :date, :historic
  attr_accessible :licitation, :process

  attr_accessor :licitation, :process

  has_enumeration_for :status, :with => ReserveFundStatus, :create_helpers => true

  belongs_to :entity
  belongs_to :budget_allocation
  belongs_to :reserve_allocation_type
  belongs_to :licitation_modality
  belongs_to :creditor

  has_many :pledges, :dependent => :restrict

  delegate :amount, :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :licitation?, :to => :reserve_allocation_type, :allow_nil => true

  validates :entity, :budget_allocation, :value, :year, :reserve_allocation_type, :date, :presence => true
  validates :year, :presence => true, :mask => '9999'
  validates :licitation, :process, :format => /^(\d+)\/\d{4}$/, :allow_blank => true

  before_save :parse_licitation, :parse_process

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
end
