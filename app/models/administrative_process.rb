class AdministrativeProcess < Compras::Model
  attr_accessible :responsible_id, :process, :year, :date
  attr_accessible :modality, :protocol, :object_type, :status, :description
  attr_accessible :judgment_form_id, :administrative_process_budget_allocations_attributes

  attr_readonly :process, :year

  attr_modal :year, :process, :protocol

  has_enumeration_for :modality, :with => AdministrativeProcessModality, :create_helpers => true
  has_enumeration_for :object_type, :with => AdministrativeProcessObjectType, :create_helpers => true
  has_enumeration_for :status, :with => AdministrativeProcessStatus, :create_helpers => true, :create_scopes => true

  belongs_to :responsible, :class_name => 'Employee'
  belongs_to :judgment_form

  has_one :licitation_process, :dependent => :restrict
  has_one :administrative_process_liberation, :dependent => :destroy
  has_many :administrative_process_budget_allocations, :dependent => :destroy, :order => :id
  has_many :items, :through => :administrative_process_budget_allocations, :order => :id

  accepts_nested_attributes_for :administrative_process_budget_allocations, :allow_destroy => true

  delegate :kind, :best_technique?, :technical_and_price?,
           :to => :judgment_form, :allow_nil => true, :prefix => true

  delegate :type_of_calculation, :to => :licitation_process, :allow_nil => true

  validates :year, :date, :presence => true
  validates :modality, :object_type, :presence => true
  validates :responsible, :status, :presence => true
  validates :description, :judgment_form, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :administrative_process_budget_allocations, :no_duplication => :budget_allocation_id

  validate :validate_modality

  before_create :set_process

  orderize :year
  filterize

  def to_s
    "#{process}/#{year}"
  end

  def total_allocations_value
    administrative_process_budget_allocations.sum(:value)
  end

  def invited?
    invitation_for_constructions_engineering_services? || invitation_for_purchases_and_engineering_services?
  end

  def signatures(signature_configuration_item = SignatureConfigurationItem)
    signature_configuration_item.all_by_configuration_report(SignatureReport::ADMINISTRATIVE_PROCESSES)
  end

  def update_status(new_status)
    update_column :status, new_status
  end

  def allow_licitation_process?
    purchase_and_services? || construction_and_engineering_services?
  end

  protected

  def set_process
    last = self.class.where(:year => year).last

    if last
      self.process = last.process.to_i + 1
    else
      self.process = 1
    end
  end

  def validate_modality(verificator = AdministrativeProcessModalitiesByObjectType.new)
    return unless object_type.present? && modality.present?

    unless verificator.verify_modality(object_type, modality)
      errors.add(:modality, :inclusion)
    end
  end
end
