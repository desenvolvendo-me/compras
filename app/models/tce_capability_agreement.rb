class TceCapabilityAgreement < Compras::Model
  attr_accessible :tce_specification_capability_id, :agreement_id

  belongs_to :tce_specification_capability
  belongs_to :agreement

  delegate :inactive?, :to => :agreement, :allow_nil => true

  validates :tce_specification_capability, :agreement, :presence => true
end
