class Pledge < ActiveRecord::Base
  attr_accessible :entity_id, :year, :management_unit_id, :emission_date, :commitment_type_id,
                  :budget_allocation_id, :value, :pledge_category_id, :expense_kind_id, :pledge_historic_id,
                  :management_contract_id, :licitation_modality_id, :description, :licitation, :process,
                  :reserve_fund_id, :material_kind, :founded_debt_contract_id, :creditor_id

  delegate :signature_date, :to => :management_contract, :allow_nil => true, :prefix => true

  attr_accessor :licitation, :process

  orderize :emission_date
  filterize

  delegate :amount, :function, :subfunction, :government_program, :government_action, :organogram, :expense_economic_classification,
           :to => :budget_allocation, :allow_nil => true, :prefix => true

  delegate :value, :to => :reserve_fund, :allow_nil => true, :prefix => true

  has_enumeration_for :material_kind

  belongs_to :creditor
  belongs_to :founded_debt_contract
  belongs_to :entity
  belongs_to :reserve_fund
  belongs_to :management_unit
  belongs_to :commitment_type
  belongs_to :budget_allocation
  belongs_to :pledge_category
  belongs_to :expense_kind
  belongs_to :pledge_historic
  belongs_to :management_contract
  belongs_to :licitation_modality

  validates :year, :mask => '9999'
  validates :emission_date, :timeliness => { :on_or_after => Date.current, :type => :date }
  validates :licitation, :process, :presence => true
  validates :licitation, :process, :format => /^(\d+)\/\d{4}$/, :allow_blank => true

  def to_s
    id.to_s
  end

  def joined_licitation
    "#{licitation_number}/#{licitation_year}" if licitation_number && licitation_year
  end

  def joined_process
    "#{process_number}/#{process_year}" if process_number && process_year
  end

  before_save :parse_licitation, :parse_process

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
end
