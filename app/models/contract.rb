class Contract < Compras::Model
  attr_accessible :year, :entity_id, :contract_number, :sequential_number, :publication_date, :lawyer_code, :contract_file
  attr_accessible :signature_date, :end_date, :description, :kind, :content, :execution_type, :contract_guarantees
  attr_accessible :contract_value, :guarantee_value, :contract_validity, :subcontracting, :cancellation_date, :cancellation_reason
  attr_accessible :dissemination_source_id, :creditor_id, :service_or_contract_type_id, :licitation_process_id
  attr_accessible :direct_purchase_id, :budget_structure_id, :budget_structure_responsible_id, :lawyer_id, :parent_id

  acts_as_nested_set
  mount_uploader :contract_file, DocumentUploader

  has_enumeration_for :kind, :with => ContractKind, :create_scopes => true
  has_enumeration_for :execution_type
  has_enumeration_for :contract_guarantees
  has_enumeration_for :subcontracting

  belongs_to :entity
  belongs_to :dissemination_source
  belongs_to :creditor
  belongs_to :service_or_contract_type
  belongs_to :licitation_process
  belongs_to :direct_purchase
  belongs_to :budget_structure
  belongs_to :budget_structure_responsible, :class_name => 'Employee'
  belongs_to :lawyer, :class_name => 'Employee'

  has_many :pledges, :dependent => :restrict

  validates :sequential_number, :year, :entity, :contract_number, :presence => true
  validates :year, :mask => "9999", :allow_blank => true
  validates :direct_purchase, :presence => true, :unless => lambda { |c| c.licitation_process.present? }
  validates :licitation_process, :presence => true, :unless => lambda { |c| c.direct_purchase.present? }
  validates :end_date, :timeliness => { :after => :signature_date, :type => :date, :allow_blank => true }

  orderize :contract_number
  filterize

  scope :founded, joins { service_or_contract_type }.where { service_or_contract_type.service_goal.eq(ServiceGoal::FOUNDED) }
  scope :management, joins { service_or_contract_type }.where { service_or_contract_type.service_goal.eq(ServiceGoal::CONTRACT_MANAGEMENT) }

  def to_s
    contract_number
  end

  def self.next_sequential(year, entity_id)
    self.where { (self.year.eq(year)) & (self.entity_id.eq(entity_id)) }.size + 1
  end
end
