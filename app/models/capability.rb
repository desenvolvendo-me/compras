class Capability < Compras::Model
  attr_accessible :descriptor_id, :description, :goal, :kind, :status
  attr_accessible :capability_destination_id, :tce_specification_capability_id

  attr_modal :descriptor_id, :description, :kind, :status

  has_enumeration_for :kind, :with => CapabilityKind
  has_enumeration_for :status, :create_helpers => true
  has_enumeration_for :source

  belongs_to :descriptor
  belongs_to :capability_destination
  belongs_to :tce_specification_capability

  has_many :budget_allocations, :dependent => :restrict
  has_many :licitation_processes, :dependent => :restrict
  has_many :extra_credit_moviment_types, :dependent => :restrict
  has_many :bank_account_capabilities, :dependent => :restrict

  validates :descriptor, :description, :goal, :kind, :status, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
