class Contract < Compras::Model
  attr_accessible :year, :contract_number, :sequential_number, :publication_date, :lawyer_code, :contract_file
  attr_accessible :signature_date, :end_date, :description, :kind, :content, :execution_type, :contract_guarantees
  attr_accessible :contract_value, :guarantee_value, :contract_validity, :subcontracting, :cancellation_date, :cancellation_reason
  attr_accessible :dissemination_source_id, :creditor_id, :service_or_contract_type_id, :licitation_process_id
  attr_accessible :direct_purchase_id, :budget_structure_id, :budget_structure_responsible_id, :lawyer_id, :parent_id
  attr_accessible :delivery_schedules_attributes

  attr_modal :year, :contract_number, :sequential_number, :signature_date

  acts_as_nested_set
  mount_uploader :contract_file, DocumentUploader

  has_enumeration_for :kind, :with => ContractKind, :create_helpers => true
  has_enumeration_for :execution_type
  has_enumeration_for :contract_guarantees

  belongs_to :dissemination_source
  belongs_to :creditor
  belongs_to :service_or_contract_type
  belongs_to :licitation_process
  belongs_to :direct_purchase
  belongs_to :budget_structure
  belongs_to :budget_structure_responsible, :class_name => 'Employee'
  belongs_to :lawyer, :class_name => 'Employee'

  has_many :pledges, :dependent => :restrict
  has_many :founded_debt_pledges, :class_name => 'Pledge', :dependent => :restrict, :foreign_key => 'founded_debt_contract_id'
  has_many :delivery_schedules, :dependent => :destroy, :order => :sequence
  has_many :occurrence_contractual_historics, :dependent => :restrict
  has_many :contract_terminations, :dependent => :restrict

  accepts_nested_attributes_for :delivery_schedules, :allow_destroy => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :sequential_number, :year, :contract_number, :publication_date, :presence => true
  validates :dissemination_source, :content, :creditor, :execution_type, :service_or_contract_type, :presence => true
  validates :contract_guarantees, :contract_value, :contract_validity, :signature_date, :presence => true
  validates :end_date, :budget_structure, :budget_structure_responsible, :kind, :presence => true
  validates :parent, :presence => true, :if => :amendment?
  validates :end_date, :timeliness => {
    :after => :signature_date,
    :type => :date,
    :after_message => :end_date_should_be_after_signature_date
  }, :allow_blank => true
  validate :presence_of_licitation_process_or_direct_purchase

  orderize :contract_number
  filterize

  scope :founded, joins { service_or_contract_type }.where { service_or_contract_type.service_goal.eq(ServiceGoal::FOUNDED) }
  scope :management, joins { service_or_contract_type }.where { service_or_contract_type.service_goal.eq(ServiceGoal::CONTRACT_MANAGEMENT) }

  def to_s
    contract_number
  end

  def modality_humanize
    licitation_process.try(:administrative_process_modality_humanize) || direct_purchase.try(:modality_humanize)
  end

  def self.next_sequential(year)
    self.where { self.year.eq year }.size + 1
  end

  # It's a XNOR validation.
  # Must have licitation process or direct purchase,
  # but not both and not neither one.
  def presence_of_licitation_process_or_direct_purchase
    unless licitation_process.present? ^ direct_purchase.present?
      errors.add :licitation_process, :must_select_licitation_process_or_direct_purchase
    end
  end

  def all_pledges
    (pledges + founded_debt_pledges).uniq
  end

  def all_pledges_total_value
    all_pledges.sum(&:value)
  end
end
