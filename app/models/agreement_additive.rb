class AgreementAdditive < Compras::Model
  attr_accessible :kind, :regulatory_act_id, :value, :description, :number

  has_enumeration_for :kind, :with => AgreementAdditiveKind, :create_helpers => { :prefix => true }

  delegate :year, :to => :agreement, :allow_nil => true

  belongs_to :agreement
  belongs_to :regulatory_act

  validates :description, :kind, :regulatory_act, :presence => true
  validates :value, :presence => true, :if => :kind_value?
end
