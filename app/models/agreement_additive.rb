class AgreementAdditive < Compras::Model
  attr_accessible :kind, :regulatory_act_id, :value, :description

  has_enumeration_for :kind, :with => AgreementAdditiveKind

  belongs_to :agreement
  belongs_to :regulatory_act

  validates :description, :kind, :regulatory_act, :value, :presence => true
end
