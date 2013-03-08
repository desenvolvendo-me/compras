class Contract < Compras::Model
  attr_accessible :year, :contract_number, :sequential_number, :publication_date,
                  :lawyer_code, :contract_file, :signature_date, :end_date,
                  :description, :kind, :content, :contract_value,
                  :guarantee_value, :contract_validity, :subcontracting,
                  :cancellation_date, :cancellation_reason, :delivery_schedules_attributes,
                  :dissemination_source_id, :creditor_id, :contract_type_id,
                  :licitation_process_id, :direct_purchase_id,
                  :budget_structure_id, :budget_structure_responsible_id,
                  :lawyer_id, :parent_id

  attr_modal :year, :contract_number, :sequential_number, :signature_date

  acts_as_nested_set
  mount_uploader :contract_file, UnicoUploader

  has_enumeration_for :kind, :with => ContractKind, :create_helpers => true

  belongs_to :budget_structure
  belongs_to :budget_structure_responsible, :class_name => 'Employee'
  belongs_to :contract_type
  belongs_to :creditor
  belongs_to :direct_purchase
  belongs_to :dissemination_source
  belongs_to :lawyer, :class_name => 'Employee'
  belongs_to :licitation_process

  has_many :delivery_schedules, :dependent => :destroy, :order => :sequence
  has_many :founded_debt_pledges, :class_name => 'Pledge', :dependent => :restrict, :foreign_key => 'founded_debt_contract_id'
  has_many :occurrence_contractual_historics, :dependent => :restrict
  has_many :pledges, :dependent => :restrict

  has_one :contract_termination, :dependent => :restrict

  accepts_nested_attributes_for :delivery_schedules, :allow_destroy => true

  delegate :execution_type_humanize, :contract_guarantees_humanize, :to => :licitation_process, :allow_nil => true
  delegate :modality_humanize, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :modality_humanize, :to => :direct_purchase, :allow_nil => true, :prefix => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :sequential_number, :year, :contract_number, :publication_date, :presence => true
  validates :dissemination_source, :content, :creditor, :contract_type, :presence => true
  validates :contract_value, :contract_validity, :signature_date, :presence => true
  validates :end_date, :budget_structure, :budget_structure_responsible, :kind, :presence => true
  validates :parent, :presence => true, :if => :amendment?
  validates :end_date, :timeliness => {
    :after => :signature_date,
    :type => :date,
    :after_message => :end_date_should_be_after_signature_date
  }, :allow_blank => true
  validate :presence_of_licitation_process_or_direct_purchase

  orderize "id DESC"
  filterize

  scope :founded, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::FOUNDED) }
  scope :management, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::CONTRACT_MANAGEMENT) }

  def to_s
    contract_number
  end

  def modality_humanize
    licitation_process_modality_humanize || direct_purchase_modality_humanize
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

  def allow_termination?
    contract_termination.blank?
  end
end
