class AgreementOccurrence < Compras::Model
  attr_accessible :kind, :date, :description

  has_enumeration_for :kind, :with => AgreementOccurrenceKind

  belongs_to :agreement

  validates :kind, :date, :description, :presence => true

  def inactive?
    AgreementOccurrenceKind.inactive_kinds.map { |k| k[1] }.include? kind
  end
end
