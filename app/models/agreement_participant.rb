class AgreementParticipant < Compras::Model
  attr_accessible :kind, :creditor_id, :value, :governmental_sphere

  has_enumeration_for :kind, :with => AgreementParticipantKind, :create_helpers => true
  has_enumeration_for :governmental_sphere, :with => AgreementGovernmentalSphere

  belongs_to :agreement
  belongs_to :creditor

  validates :kind, :creditor, :value, :governmental_sphere, :presence => true
end
