class AgreementOccurrence < Compras::Model
  attr_accessible :kind, :date, :description

  has_enumeration_for :kind, :with => AgreementOccurrenceKind, :create_helpers => true

  belongs_to :agreement

  validates :kind, :date, :description, :presence => true

  def active?
    in_progress?
  end
end
