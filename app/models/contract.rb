class Contract < Compras::Model
  include BelongsToResource

  attr_accessible :year, :contract_number, :sequential_number, :publication_date,
                  :lawyer_code, :contract_file, :signature_date, :end_date,
                  :description, :content, :contract_value,
                  :guarantee_value, :contract_validity, :subcontracting,
                  :cancellation_date, :cancellation_reason, :delivery_schedules_attributes,
                  :dissemination_source_id, :creditor_ids, :contract_type_id,
                  :licitation_process_id, :start_date,
                  :budget_structure_id, :budget_structure_responsible_id,
                  :lawyer_id, :parent_id, :additives_attributes, :penalty_fine,
                  :default_fine, :execution_type, :contract_guarantees, :consortium_agreement

  attr_modal :year, :contract_number, :sequential_number, :signature_date

  attr_accessor :creditor

  acts_as_nested_set
  mount_uploader :contract_file, UnicoUploader

  has_enumeration_for :contract_guarantees, :with => UnicoAPI::Resources::Compras::Enumerations::ContractGuarantees
  has_enumeration_for :execution_type, :create_helpers => true

  belongs_to :budget_structure_responsible, :class_name => 'Employee'
  belongs_to :contract_type
  belongs_to :dissemination_source
  belongs_to :lawyer, :class_name => 'Employee'
  belongs_to :licitation_process

  belongs_to_resource :budget_structure

  has_many :additives, class_name: 'ContractAdditive', dependent: :restrict
  has_many :delivery_schedules, :dependent => :destroy, :order => :sequence
  has_many :occurrence_contractual_historics, :dependent => :restrict
  has_many :ratifications, through: :licitation_process, source: :licitation_process_ratifications
  has_many :ratifications_items, through: :ratifications, source: :licitation_process_ratification_items

  has_and_belongs_to_many :creditors, join_table: :compras_contracts_unico_creditors, order: :id

  has_one :contract_termination, :dependent => :restrict

  accepts_nested_attributes_for :additives, :allow_destroy => true
  accepts_nested_attributes_for :delivery_schedules, :allow_destroy => true

  delegate :execution_type_humanize, :contract_guarantees_humanize, :contract_guarantees,
    :to => :licitation_process, :allow_nil => true
  delegate :budget_allocations_ids, :modality_humanize, :process, :execution_unit_responsible, :year, :type_of_removal_humanize,
    :to => :licitation_process, :allow_nil => true, :prefix => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :sequential_number, :year, :contract_number, :publication_date,
    :dissemination_source, :content, :creditor_ids, :contract_type,
    :contract_value, :contract_validity, :signature_date, :start_date,
    :end_date, :budget_structure_id, :budget_structure_responsible,
    :default_fine, :penalty_fine, :presence => true
  validates :end_date, :timeliness => {
    :after => :signature_date,
    :type => :date,
    :after_message => :end_date_should_be_after_signature_date
  }, :allow_blank => true

  validate :presence_of_at_least_one_creditor
  validate :must_not_be_greater_than_one_creditor, unless: :consortium_agreement?
  validate :check_budget_structure, on: :create

  orderize "id DESC"
  filterize

  scope :founded, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::FOUNDED) }
  scope :management, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::CONTRACT_MANAGEMENT) }
  scope :by_signature_date, lambda { |date_range|
    where { signature_date.in(date_range) }
  }

  scope :by_signature_period, lambda { |started_at, ended_at|
    where { signature_date.gteq(started_at) & signature_date.lteq(ended_at) }
  }

  scope :purchase_process_id, ->(purchase_process_id) do
    where { |query| query.licitation_process_id.eq(purchase_process_id) }
  end

  scope :except_type_of_removal, ->(type_of_removal) do
    joins { licitation_process }.
    where { licitation_process.type_of_removal.not_eq(type_of_removal) |
      licitation_process.type_of_removal.eq(nil)
     }
  end

  def to_s
    contract_number
  end

  def modality_humanize
    if licitation_process && licitation_process.direct_purchase?
      licitation_process_type_of_removal_humanize
    else
      licitation_process_modality_humanize
    end
  end

  def self.next_sequential(year)
    self.where { self.year.eq year }.size + 1
  end

  def pledges
    Pledge.all(params: { by_contract_id: id })
  end

  def founded_debt_pledges
    Pledge.all(params: { by_founded_debt_contract_id: id })
  end

  def all_pledges
    (pledges + founded_debt_pledges).uniq
  end

  def all_pledges_total_value
    all_pledges.sum(&:amount)
  end

  def allow_termination?
    contract_termination.blank?
  end

  private

  def presence_of_at_least_one_creditor
    errors.add(:creditors, :blank) if creditors.empty?
  end

  def must_not_be_greater_than_one_creditor
    errors.add(:creditors, :must_not_be_greater_than_one_creditor) if creditor_ids.count > 1
  end

  def check_budget_structure
    return if budget_structure_id.present?
    errors.add(:budget_structure, :blank) if budget_structure.blank?
  end
end
