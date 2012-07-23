class OccurrenceContractualHistoric < Compras::Model
  attr_accessible :observations, :occurrence_contractual_historic_change, :occurrence_contractual_historic_type
  attr_accessible :contract_id, :occurrence_date

  attr_readonly :sequence

  auto_increment :sequence, :by => :contract_id

  has_enumeration_for :occurrence_contractual_historic_change
  has_enumeration_for :occurrence_contractual_historic_type

  belongs_to :contract

  validates :observations, :occurrence_contractual_historic_change, :presence => true
  validates :occurrence_contractual_historic_type, :occurrence_date, :presence => true

  orderize :sequence
  filterize

  def to_s
    sequence.to_s
  end
end
