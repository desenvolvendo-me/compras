class Contract < Compras::Model
  attr_accessible :year, :contract_number, :sequential_number, :publication_date,
                  :lawyer_code, :contract_file, :signature_date, :end_date,
                  :description, :kind, :content, :contract_value,
                  :guarantee_value, :contract_validity, :subcontracting,
                  :cancellation_date, :cancellation_reason, :delivery_schedules_attributes,
                  :dissemination_source_id, :creditor_id, :contract_type_id,
                  :licitation_process_id, :start_date,
                  :budget_structure_id, :budget_structure_responsible_id,
                  :lawyer_id, :parent_id, :additives_attributes, :penalty_fine,
                  :default_fine, :execution_type, :contract_guarantees

  attr_modal :year, :contract_number, :sequential_number, :signature_date

  acts_as_nested_set
  mount_uploader :contract_file, UnicoUploader

  has_enumeration_for :kind, :with => ContractKind, :create_helpers => true
  has_enumeration_for :contract_guarantees
  has_enumeration_for :execution_type, :create_helpers => true

  belongs_to :budget_structure
  belongs_to :budget_structure_responsible, :class_name => 'Employee'
  belongs_to :contract_type
  belongs_to :creditor
  belongs_to :dissemination_source
  belongs_to :lawyer, :class_name => 'Employee'
  belongs_to :licitation_process

  has_many :additives, class_name: 'ContractAdditive', dependent: :restrict
  has_many :delivery_schedules, :dependent => :destroy, :order => :sequence
  has_many :founded_debt_pledges, :class_name => 'Pledge', :dependent => :restrict, :foreign_key => 'founded_debt_contract_id'
  has_many :occurrence_contractual_historics, :dependent => :restrict
  has_many :pledges, :dependent => :restrict

  has_one :contract_termination, :dependent => :restrict

  accepts_nested_attributes_for :additives, :allow_destroy => true
  accepts_nested_attributes_for :delivery_schedules, :allow_destroy => true

  delegate :modality_humanize, :type_of_removal_humanize, :to => :licitation_process, :allow_nil => true, :prefix => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :sequential_number, :year, :contract_number, :publication_date,
    :dissemination_source, :content, :creditor, :contract_type,
    :contract_value, :contract_validity, :signature_date, :start_date,
    :end_date, :budget_structure, :budget_structure_responsible, :kind,
    :default_fine, :penalty_fine, :presence => true
  validates :parent, :presence => true, :if => :amendment?
  validates :end_date, :timeliness => {
    :after => :signature_date,
    :type => :date,
    :after_message => :end_date_should_be_after_signature_date
  }, :allow_blank => true

  orderize "id DESC"
  filterize

  scope :founded, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::FOUNDED) }
  scope :management, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::CONTRACT_MANAGEMENT) }

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
