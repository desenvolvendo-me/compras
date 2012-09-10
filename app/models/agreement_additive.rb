class AgreementAdditive < Compras::Model
  attr_accessible :kind, :regulatory_act_id, :value, :description, :number

  has_enumeration_for :kind, :with => AgreementAdditiveKind

  delegate :number_year, :to => :agreement, :allow_nil => true

  belongs_to :agreement
  belongs_to :regulatory_act

  validates :description, :kind, :regulatory_act, :value, :presence => true

  def year
    number_year.split('/').last
  end
end
